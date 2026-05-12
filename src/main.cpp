#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QScreen>
#include <cstdio>

#include "configmanager.h"

int main(int argc, char* argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu");

    ConfigManager configManager;
    QQmlApplicationEngine engine;

    // Add config dir to import paths for user MyStyle.qml
    engine.rootContext()->setContextProperty("ConfigManager", &configManager);
    engine.addImportPath(configManager.configDir());

    // loadFromModule is the correct way to load a qml module
    engine.loadFromModule("niripwmenu", "Main");

    if (engine.rootObjects().isEmpty()) {
        // Fallback: try to understand why
        fprintf(stderr, "loadFromModule failed\n");
        return 1;
    }

    QWindow* win = qobject_cast<QWindow*>(engine.rootObjects().first());
    if (win) {
        QScreen* sc = QGuiApplication::primaryScreen();
        if (sc) {
            QRect r = sc->geometry();
            win->setX((r.width() - win->width()) / 2);
            win->setY((r.height() - win->height()) / 2);
        } else {
            win->setX(100);
            win->setY(100);
        }
        win->requestActivate();
    }

    return app.exec();
}