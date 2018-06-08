#include <fstream>
#include <sstream>

#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QProcess>
#include <QFileInfo>

#include "passwordmanager.h"

const QString PasswordManager::LAST_FILE = "lastFile";

PasswordManager::PasswordManager() :
    m_cipherer(),
    m_passwords(),
    m_currentId(0)
{

}

bool PasswordManager::initialize(const QString &applicationPath)
{
    return m_cipherer.initialize(applicationPath);
}

bool PasswordManager::load(const QUrl &passfile, const QString &password)
{
    QFile   file(passfile.toLocalFile());

    if (!file.open(QFile::ReadOnly))
    {
        qWarning() << "Error: Cannot open file " << passfile.toLocalFile() << ": " << file.errorString();
        return false;
    }

    QByteArray data;

    if (!m_cipherer.decrypt(file.readAll(), data, password))
    {
        return false;
    }

    QJsonDocument doc;

    doc = QJsonDocument::fromJson(data);
    m_passwords.clear();
    emit passwordsChanged(passwords());
    m_currentId = 0;
    for (QJsonValueRef const &curr : doc["passwords"].toArray())
    {
        Password *toadd = newPassword();

        toadd->setName(curr.toObject()["name"].toString());
        toadd->setDescription(curr.toObject()["description"].toString());
        toadd->setPassword(curr.toObject()["password"].toString());
    }
    emit loaded(passfile);
    file.close();
    return true;
}

bool PasswordManager::save(const QUrl &passfile, QString const &password)
{
    QJsonObject obj;
    QJsonArray arr;
    QByteArray data;

    for (Password *curr : m_passwords)
    {
        arr.append(*curr);
    }
    obj.insert("passwords", QJsonValue(arr));
    if (m_cipherer.encrypt(QJsonDocument(obj).toJson(QJsonDocument::JsonFormat::Compact), data, password))
    {
        QFile file(passfile.toLocalFile());

        if (file.open(QFile::WriteOnly))
        {
            file.write(data);
            file.close();
            emit saved(passfile);
            return true;
        }
        else
        {
            qWarning() << "Error: Cannot open file " << passfile.toLocalFile() << ": " << file.errorString();
        }
    }
    return false;
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

const QString &PasswordManager::lastFileOpened() const
{
    return m_lastFileOpened;
}

void PasswordManager::setLastFileOpened(const QString &value)
{
    m_lastFileOpened = value;
}

Password *PasswordManager::newPassword()
{
    Password *toadd = new Password();

    toadd->setId(m_currentId++);
    m_passwords[toadd->id()] = toadd;
    emit passwordsChanged(passwords());
    return toadd;
}

void PasswordManager::removePassword(quint32 id)
{
    m_passwords.remove(id);
    emit passwordsChanged(passwords());
}
