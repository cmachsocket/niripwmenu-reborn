#include <QObject>
#include <QProcess>
#include <QVariantList>

class System : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE static void exec(const QString& cmd) {
        QProcess::startDetached("/bin/sh", {"-c", cmd});
    }
};