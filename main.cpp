#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "password.h"
#include "passwordmanager.h"

QObject *managerSingleton(QQmlEngine *, QJSEngine *)
{
    PasswordManager *toret = new PasswordManager();

    Password *pass = toret->newPassword();
    pass->setName("Facebook");
    pass->setDescription("Mot de passe facebook");
    pass->setPassword("toto42");

    pass = toret->newPassword();
    pass->setName("Twitter");
    pass->setDescription("Mot de passe twitter");
    pass->setPassword("toto42");

    pass = toret->newPassword();
    pass->setName("Google");
    pass->setDescription("Mot de passe google, youtube, gmail, gmap, google drive et tout ce que fait google");
    pass->setPassword("toto42");

    /*pass = toret->newPassword();
    pass->setName("PC");
    pass->setDescription("Mot de passe pc");
    pass->setPassword("toto42");*/

    return toret;
}

int main(int argc, char *argv[])
{
    qmlRegisterType<Password>("Chest", 1, 0, "Password");
    qmlRegisterSingletonType<PasswordManager>("Chest", 1, 0, "PasswordManager", managerSingleton);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
