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

QString ConfigManager::defaultConfigJson()
{
    QJsonArray arr;
    QJsonObject obj0;
    obj0.insert("icon", "qrc:///data/shutdown.png");
    obj0.insert("id", "b0");
    obj0.insert("hint", "Power Off");
    obj0.insert("command", "poweroff");
    QJsonObject obj1;
    obj1.insert("icon", "qrc:///data/reboot.png");
    obj1.insert("id", "b1");
    obj1.insert("hint", "Restart");
    obj1.insert("command", "reboot");
    QJsonObject obj2;
    obj2.insert("icon", "qrc:///data/logoff.png");
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

void ConfigManager::ensureConfig()
{
    QString dir = configDir();
    QDir().mkpath(dir);
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
    return QString::fromUtf8(data);
}

void ConfigManager::writeConfig(const QString& json) const
{
    QString path = QDir(configDir()).filePath("config.json");
    QFile f(path);
    if (f.open(QIODevice::WriteOnly | QIODevice::Text))
        f.write(json.toUtf8());
}

void ConfigManager::exec(const QString& cmd)
{
    QProcess::startDetached("/bin/sh", QStringList() << "-c" << cmd);
}