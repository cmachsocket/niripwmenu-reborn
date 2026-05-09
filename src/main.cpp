#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QScreen>
#include <QWindow>

#include "system.h"

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu");

    // Register System singleton for QML
    qmlRegisterSingletonType<System>(
        "niripwmenu", 1, 0, "System",
        [](QQmlEngine*, QJSEngine*) -> QObject* { return new System(); }
    );

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:///src/qml/Main.qml"));

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [&app](QObject* obj, const QUrl&) {
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
