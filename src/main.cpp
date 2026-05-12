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

    // Debug: show config dir
    fprintf(stderr, "DEBUG configDir: %s\n", qPrintable(configManager.configDir()));
    fprintf(stderr, "DEBUG styleFile: %s\n", qPrintable(configManager.styleFile()));
    fprintf(stderr, "DEBUG getTheme: %s\n", qPrintable(configManager.getTheme()));

    engine.rootContext()->setContextProperty("ConfigManager", &configManager);
    engine.addImportPath(configManager.configDir());

    engine.loadFromModule("niripwmenu", "Main");

    if (engine.rootObjects().isEmpty()) {
        fprintf(stderr, "ALL LOADS FAILED\n");
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