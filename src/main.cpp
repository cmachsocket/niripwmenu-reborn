#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QScreen>
#include <QKeyEvent>
#include <cstdio>

#include "configmanager.h"

class KeyFilter : public QObject {
public:
    explicit KeyFilter(ConfigManager* cm, QObject* parent = nullptr)
        : QObject(parent), m_cm(cm), m_dark(false) {}

    bool eventFilter(QObject* watched, QEvent* event) override {
        if (event->type() == QEvent::KeyPress) {
            QKeyEvent* ke = static_cast<QKeyEvent*>(event);
            if (ke->key() == Qt::Key_Tab) {
                fprintf(stderr, "DEBUG Tab pressed\n");
                m_dark = !m_dark;
                m_cm->setTheme(m_dark ? "dark" : "light");
            } else if (ke->key() == Qt::Key_Escape) {
                fprintf(stderr, "DEBUG Escape pressed\n");
                QCoreApplication::quit();
            }
        }
        return QObject::eventFilter(watched, event);
    }

private:
    ConfigManager* m_cm;
    bool m_dark;
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

    engine.loadFromModule("niripwmenu", "Main");

    if (engine.rootObjects().isEmpty()) {
        fprintf(stderr, "ALL LOADS FAILED\n");
        return 1;
    }

    QWindow* win = qobject_cast<QWindow*>(engine.rootObjects().first());
    if (win) {
        KeyFilter* keyFilter = new KeyFilter(&configManager, &engine);
        win->installEventFilter(keyFilter);

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