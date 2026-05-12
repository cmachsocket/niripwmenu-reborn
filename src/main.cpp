#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QScreen>
#include <QKeyEvent>
#include <cstdio>

#include "configmanager.h"

class GlobalKeyFilter : public QObject {
public:
    explicit GlobalKeyFilter(ConfigManager* cm, QObject* parent = nullptr)
        : QObject(parent), m_cm(cm) {}

    bool eventFilter(QObject* watched, QEvent* event) override {
        if (event->type() == QEvent::KeyPress) {
            QKeyEvent* ke = static_cast<QKeyEvent*>(event);
            int key = ke->key();
            // Left/Right: signal to QML via ConfigManager.lastKey
            if (key == Qt::Key_Left || key == Qt::Key_Right) {
                QString k = (key == Qt::Key_Left) ? "left" : "right";
                m_cm->setLastKey(k);
            }
            // Escape: quit
            if (key == Qt::Key_Escape) {
                QCoreApplication::quit();
            }
        }
        return false; // don't consume, let QML handle too
    }

private:
    ConfigManager* m_cm;
};

int main(int argc, char* argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    QGuiApplication app(argc, argv);
    app.setApplicationName("niripwmenu");

    ConfigManager configManager;
    QQmlApplicationEngine engine;

    fprintf(stderr, "DEBUG configDir: %s\n", qPrintable(configManager.configDir()));
    fprintf(stderr, "DEBUG getTheme: %s\n", qPrintable(configManager.getTheme()));

    engine.rootContext()->setContextProperty("ConfigManager", &configManager);
    engine.addImportPath(configManager.configDir());

    // Left/Right key events from C++ → QML signal
    app.installEventFilter(new GlobalKeyFilter(&configManager, &engine));

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