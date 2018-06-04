#ifndef PASSWORDMANAGER_H
#define PASSWORDMANAGER_H

#include <QObject>
#include <QList>

#include "password.h"

class PasswordManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QVariant> passwords READ passwords NOTIFY passwordsChanged)

public:
    PasswordManager();

public:
    Q_INVOKABLE void load(QString const &passfile, QString const &password);
    Q_INVOKABLE void save(QString const &passfile);

public:
    QList<QVariant> passwords() const;

public:
    Q_INVOKABLE Password *newPassword();
    Q_INVOKABLE void removePassword(int index);

signals:
    void passwordsChanged(QList<QVariant> const &passwords);

private:
    QList<Password *>   m_passwords;
};

#endif // PASSWORDMANAGER_H
