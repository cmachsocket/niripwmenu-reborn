#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QScreen>
#include <cstdlib>

#include "configmanager.h"

int main(int argc, char* argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu");

    // ConfigManager singleton — config init, read, write, exec
    qmlRegisterSingletonType<ConfigManager>(
        "niripwmenu", 1, 0, "ConfigManager",
        [](QQmlEngine*, QJSEngine*) -> QObject* { return new ConfigManager(); }
    );

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///src/qml/Main.qml")));

    QWindow* win = qobject_cast<QWindow*>(engine.rootObjects().first());
    if (win) {
        QScreen* sc = app.primaryScreen();
        if (sc) {
            QRect r = sc->geometry();
            win->setX((r.width() - win->width()) / 2);
            win->setY((r.height() - win->height()) / 2);
        }
        win->requestActivate();
    }

    return app.exec();
}