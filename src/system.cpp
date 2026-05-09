#include "system.h"

#include <QCoreApplication>

System* System::s_instance = nullptr;

System::System(QObject* parent)
    : QObject(parent)
{
    s_instance = this;
}

void System::exec(const QString& command)
{
    if (command.isEmpty())
        return;

    QProcess::startDetached("/bin/sh", {"-c", command});
}
