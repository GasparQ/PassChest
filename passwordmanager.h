#ifndef PASSWORDMANAGER_H
#define PASSWORDMANAGER_H

#include <QObject>
#include <QList>

#include "password.h"
#include "botancipher.h"

class PasswordManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QVariant> passwords READ passwords NOTIFY passwordsChanged)

public:
    PasswordManager();

public:
    bool initialize(QString const &applicationPath);

public:
    Q_INVOKABLE bool load(QUrl const &passfile, QString const &password);
    Q_INVOKABLE bool save(QUrl const &passfile);

public:
    QList<QVariant> passwords() const;

public:
    Q_INVOKABLE Password *newPassword();
    Q_INVOKABLE void removePassword(quint32 id);

signals:
    void passwordsChanged(QList<QVariant> const &passwords);
    void loaded(QUrl const &file);
    void saved(QUrl const &file);

private:
    BotanCipher m_cipherer;
    QMap<quint32, Password *>   m_passwords;
    quint32 m_currentId;
};

#endif // PASSWORDMANAGER_H
