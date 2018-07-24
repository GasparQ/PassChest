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
    m_currentId(0),
    m_filename(),
    m_opened(false)
{

}

bool PasswordManager::initialize(const QString &applicationPath)
{
    return m_cipherer.initialize(applicationPath);
}

bool PasswordManager::load(const QString &password)
{
    QFile   file(QUrl(m_filename).toLocalFile());

    if (!file.open(QFile::ReadOnly))
    {
        qWarning() << "Error: Cannot open file " << m_filename << ": " << file.errorString();
        return false;
    }

    QByteArray data;

    if (!m_cipherer.decrypt(file.readAll(), data, password))
    {
        qWarning() << "Could not decrypt file";
        return false;
    }

    QJsonDocument doc;
    QJsonParseError error;

    doc = QJsonDocument::fromJson(data, &error);

    if (doc.isNull() || doc.isEmpty())
    {
        qWarning() << "Could not parse json in file " << m_filename << ": " << error.errorString() << " (password might be invalid)";
        return false;
    }

    m_opened = false;
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
    m_opened = true;
    m_saved = true;
    emit loaded(m_filename);
    file.close();
    return true;
}

bool PasswordManager::save(const QString &password)
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
        QFile file(QUrl(m_filename).toLocalFile());

        if (file.open(QFile::WriteOnly))
        {
            file.write(data);
            file.close();
            m_saved = true;
            emit saved(m_filename);
            return true;
        }
        else
        {
            qWarning() << "Error: Cannot open file " << m_filename << ": " << file.errorString();
        }
    }
    return false;
}

void PasswordManager::reset()
{
    m_filename.clear();
    m_opened = false;
    m_passwords.clear();
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

const QString &PasswordManager::filename() const
{
    return m_filename;
}

bool PasswordManager::isOpen() const
{
    return m_opened;
}

bool PasswordManager::isSaved() const
{
    return m_saved;
}

void PasswordManager::setFilename(const QString &value)
{
    m_filename = value;
}

void PasswordManager::setSaved(bool value)
{
    m_saved = value;
}

Password *PasswordManager::newPassword()
{
    Password *toadd = new Password();

    toadd->setId(m_currentId++);
    m_passwords[toadd->id()] = toadd;
    m_saved = false;
    emit passwordsChanged(passwords());
    return toadd;
}

void PasswordManager::removePassword(quint32 id)
{
    m_passwords.remove(id);
    m_saved = false;
    emit passwordsChanged(passwords());
}
