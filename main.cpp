#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QDebug>

#include "password.h"
#include "passwordmanager.h"

PasswordManager *manager = new PasswordManager();

QObject *managerSingleton(QQmlEngine *, QJSEngine *)
{
    return manager;
}

int main(int argc, char *argv[])
{
    qmlRegisterType<Password>("Chest", 1, 0, "Password");
    qmlRegisterSingletonType<PasswordManager>("Chest", 1, 0, "PasswordManager", managerSingleton);

    QCoreApplication::setOrganizationName("GasparQ");
    QCoreApplication::setOrganizationDomain("passchest.io");
    QCoreApplication::setApplicationName("PassChest");

    QGuiApplication app(argc, argv);
    QSettings settings;

    if (settings.contains("lastFile"))
        manager->load(settings.value("lastFile").toString(), "");

    QObject::connect(manager, &PasswordManager::loaded, [&settings](QUrl const &passfile) {
        qDebug() << "Save last file value to: " << passfile.toString();
        settings.setValue("lastFile", passfile.toString());
    });

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
