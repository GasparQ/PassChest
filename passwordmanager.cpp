#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

#include "passwordmanager.h"

PasswordManager::PasswordManager()
{

}

void PasswordManager::load(const QString &passfile, const QString &password)
{

}

void PasswordManager::save(const QString &passfile)
{
    QJsonDocument doc;
    QJsonObject obj;

    QJsonArray arr;

    for (Password *curr : m_passwords) arr.append(*curr);

    obj.insert("passwords", QJsonValue(arr));
    doc.setObject(obj);

    qDebug() << doc.toJson(QJsonDocument::JsonFormat::Compact);
}

QList<QVariant> PasswordManager::passwords() const
{
    QList<QVariant> toret;

    for (Password *curr : m_passwords)
    {
        toret.append(QVariant::fromValue(curr));
    }
    return toret;
}

Password *PasswordManager::newPassword()
{
    Password *toadd = new Password();

    m_passwords.append(toadd);
    emit passwordsChanged(passwords());
    return toadd;
}

void PasswordManager::removePassword(int index)
{
    m_passwords.removeAt(index);

    emit passwordsChanged(passwords());
}
