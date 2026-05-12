#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QString>

class ConfigManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString lastKey READ lastKey NOTIFY lastKeyChanged)

public:
    explicit ConfigManager(QObject* parent = nullptr);

    Q_INVOKABLE QString configDir() const;
    Q_INVOKABLE void ensureConfig();
    Q_INVOKABLE QString getTheme() const;     // "light" or "dark"
    Q_INVOKABLE void setTheme(const QString& theme);
    Q_INVOKABLE QString loadConfig() const;   // raw JSON string
    Q_INVOKABLE void writeConfig(const QString& json) const;
    Q_INVOKABLE void exec(const QString& cmd);
    Q_INVOKABLE QString styleFile() const;    // path to MyStyle.qml in config dir
    Q_INVOKABLE void setLastKey(const QString& key);
    Q_INVOKABLE QString lastKey() const;

Q_SIGNALS:
    void lastKeyChanged(const QString& key);

private:
    static QString defaultConfigJson();
    QString m_lastKey;
};

#endif