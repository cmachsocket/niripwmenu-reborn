#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QScreen>
#include <QDirIterator>
#include <QQmlComponent>
#include <QQmlContext>
#include <dlfcn.h>
#include <cstdio>

#include "configmanager.h"

typedef void (*InitFn)();

int main(int argc, char* argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu");
    QQmlApplicationEngine engine;
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
