#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QDebug>
#include <QQuickItem>
#include <QObject>

#include "password.h"
#include "passwordmanager.h"

PasswordManager *manager = new PasswordManager();

QObject *managerSingleton(QQmlEngine *, QJSEngine *)
{
    return manager;
}

int main(int argc, char *argv[])
{
    qmlRegisterUncreatableType<Password>("Chest", 1, 0, "Password", "Passwords can only be created from PasswordManager");
    qmlRegisterSingletonType<PasswordManager>("Chest", 1, 0, "PasswordManager", managerSingleton);

    QCoreApplication::setOrganizationName("GasparQ");
    QCoreApplication::setOrganizationDomain("passchest.io");
    QCoreApplication::setApplicationName("PassChest");

    QGuiApplication app(argc, argv);
    QSettings settings;

    if (!manager->initialize(app.applicationDirPath()))
        return -1;

    std::function<void(QUrl const &)> updateSettings = [&settings](QUrl const &file) {
        settings.setValue("lastFile", file.toString());
    };

    QObject::connect(manager, &PasswordManager::loaded, updateSettings);
    QObject::connect(manager, &PasswordManager::saved, updateSettings);

    if (argc == 2)
    {
        manager->setFilename(QUrl::fromLocalFile(argv[1]).toString());
    }
    else if (settings.contains("lastFile"))
    {
        manager->setFilename(settings.value("lastFile").toString());
    }

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
