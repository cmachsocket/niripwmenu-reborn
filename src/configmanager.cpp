#include "configmanager.h"
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QProcess>
#include <QStandardPaths>

ConfigManager::ConfigManager(QObject* parent)
    : QObject(parent)
{
}

QString ConfigManager::configDir() const
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

static QString expandPath(const QString& path) {
    if (path.startsWith("file://")) {
        QString p = path.mid(7); // strip "file://"
        if (p.startsWith("~/")) {
            QString home = QDir::homePath();
            if (!home.isEmpty() && home != "/")
                p = home + '/' + p.mid(2);
        }
        return "file://" + p;
    }
    return path;
}

QString ConfigManager::defaultConfigJson()
{
    QJsonArray arr;
    QJsonObject obj0;
    obj0.insert("icon", expandPath("qrc:///data/shutdown.png"));
    obj0.insert("id", "b0");
    obj0.insert("hint", "Power Off");
    obj0.insert("command", "poweroff");
    QJsonObject obj1;
    obj1.insert("icon", expandPath("qrc:///data/reboot.png"));
    obj1.insert("id", "b1");
    obj1.insert("hint", "Restart");
    obj1.insert("command", "reboot");
    QJsonObject obj2;
    obj2.insert("icon", expandPath("qrc:///data/logoff.png"));
    obj2.insert("id", "b2");
    obj2.insert("hint", "Log Off");
    obj2.insert("command", "niri msg action quit -s");
    arr.append(obj0);
    arr.append(obj1);
    arr.append(obj2);
    QJsonObject root;
    root.insert("buttons", arr);
    QJsonDocument doc(root);
    return QString::fromUtf8(doc.toJson());
}

void ConfigManager::ensureConfig() const
{
    QString dir = configDir();
    QDir().mkpath(dir);
    QMessageLogger().debug() << "Config dir:" << dir;
    QString cfgFile = QDir(dir).filePath("config.json");
    if (!QFile::exists(cfgFile)) {
        QFile f(cfgFile);
        if (f.open(QIODevice::WriteOnly | QIODevice::Text)) {
            f.write(defaultConfigJson().toUtf8());
            f.close();
        }
    }
    QStringList icons;
    icons.append("shutdown.png");
    icons.append("reboot.png");
    icons.append("logoff.png");
    for (int i = 0; i < icons.size(); ++i) {
        QString dst = QDir(dir).filePath(icons[i]);
        if (!QFile::exists(dst)) {
            QString qrcPath = QString("qrc:///data/") + icons[i];
            QFile src(qrcPath);
            if (src.open(QIODevice::ReadOnly)) {
                QByteArray data = src.readAll();
                src.close();
                QFile out(dst);
                if (out.open(QIODevice::WriteOnly))
                    out.write(data);
            }
        }
    }
}

QString ConfigManager::loadConfig() const
{
    QString path = QDir(configDir()).filePath("config.json");
    QFile f(path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return QString();
    QByteArray data = f.readAll();
    f.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull())
        return QString::fromUtf8(data); // return raw on parse failure

    QJsonObject root = doc.object();
    QJsonArray buttons = root.value("buttons").toArray();
    for (int i = 0; i < buttons.size(); ++i) {
        QJsonObject btn = buttons[i].toObject();
        if (btn.contains("icon")) {
            btn["icon"] = expandPath(btn["icon"].toString());
            buttons[i] = btn;
        }
    }
    root["buttons"] = buttons;
    return QString::fromUtf8(QJsonDocument(root).toJson());
}

void ConfigManager::writeConfig(const QString& json) const
{
    QString path = QDir(configDir()).filePath("config.json");
    QFile f(path);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    // Expand ~ in icon paths to actual home dir before saving
    QJsonDocument doc = QJsonDocument::fromJson(json.toUtf8());
    if (!doc.isNull()) {
        QJsonObject root = doc.object();
        QJsonArray buttons = root.value("buttons").toArray();
        for (int i = 0; i < buttons.size(); ++i) {
            QJsonObject btn = buttons[i].toObject();
            if (btn.contains("icon")) {
                QString icon = btn["icon"].toString();
                if (icon.startsWith("file://") && icon.mid(7).startsWith("~/")) {
                    QString home = QDir::homePath();
                    if (!home.isEmpty() && home != "/")
                        btn["icon"] = "file://" + home + '/' + icon.mid(9);
                }
                buttons[i] = btn;
            }
        }
        root["buttons"] = buttons;
        f.write(QJsonDocument(root).toJson());
    } else {
        f.write(json.toUtf8());
    }
}

void ConfigManager::exec(const QString& cmd)
{
    QProcess::startDetached("/bin/sh", QStringList() << "-c" << cmd);
}