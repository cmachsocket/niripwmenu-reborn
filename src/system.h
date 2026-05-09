#pragma once

#include <QObject>
#include <QProcess>
#include <QQmlEngine>

class System : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit System(QObject* parent = nullptr);

    Q_INVOKABLE void exec(const QString& command);

private:
    static System* s_instance;
    static System* create(QQmlEngine*, QJSEngine*) { return new System(); }
};
