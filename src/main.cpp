#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>
#include <QWindow>
#include <QStandardPaths>
#include <QProcessEnvironment>
#include <cstdlib>
#include "system.h"

int main(int argc, char* argv[])
{

    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu-reborn");
    app.setOrganizationName("cmach_socket");
    QString configDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
    System system;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("System", &system);
    engine.rootContext()->setContextProperty("appConfigDir", configDir);

    const QUrl url(QStringLiteral("qrc:///src/qml/Main.qml"));

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [](QObject* obj, const QUrl&) {
            if (!obj)
                QCoreApplication::exit(1);
        },
        Qt::QueuedConnection
    );

    engine.load(url);
    QWindow* win = qobject_cast<QWindow*>(engine.rootObjects().first());
    if (win) {
        QScreen* screen = app.primaryScreen();
        if (screen) {
            QRect geo = screen->geometry();
            win->setX((geo.width()  - win->width())  / 2);
            win->setY((geo.height() - win->height()) / 2);
        }
        win->requestActivate();
    }

    return app.exec();
}
