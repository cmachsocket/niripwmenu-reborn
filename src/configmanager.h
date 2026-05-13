#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QString>

class ConfigManager : public QObject {
    Q_OBJECT

public:
    explicit ConfigManager(QObject* parent = nullptr);

    Q_INVOKABLE QString configDir() const;
    Q_INVOKABLE void ensureConfig() const;
    Q_INVOKABLE QString loadConfig() const;   // returns JSON string
    Q_INVOKABLE void writeConfig(const QString& json) const;
    Q_INVOKABLE static void exec(const QString& cmd);

    Q_INVOKABLE QString loadStyle() const;    // returns style JSON string
    Q_INVOKABLE void saveStyle(const QString& json) const;
    Q_INVOKABLE QString defaultStyleJson() const;

private:
    static QString defaultConfigJson();
};

#endif