#include <fstream>
#include <sstream>

#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

#include "passwordmanager.h"

PasswordManager::PasswordManager() :
    m_passwords(),
    m_currentId(0)
{

}

void PasswordManager::load(const QUrl &passfile, const QString &)
{
    QJsonDocument doc;

    std::ifstream file(passfile.toLocalFile().toStdString());

    if (file.is_open()) {
        std::stringstream stream;

        stream << file.rdbuf();
        doc = QJsonDocument::fromJson(QString::fromStdString(stream.str()).toUtf8());
        m_passwords.clear();
        emit passwordsChanged(passwords());
        m_currentId = 0;
        for (QJsonValueRef const &curr : doc["passwords"].toArray()) {
            Password *toadd = newPassword();

            toadd->setName(curr.toObject()["name"].toString());
            toadd->setDescription(curr.toObject()["description"].toString());
            toadd->setPassword(curr.toObject()["password"].toString());
        }
        file.close();
    }
}

void PasswordManager::save(const QUrl &passfile)
{
    QJsonDocument doc;
    QJsonObject obj;

    QJsonArray arr;

    for (Password *curr : m_passwords) arr.append(*curr);

    obj.insert("passwords", QJsonValue(arr));
    doc.setObject(obj);

    std::ofstream   file(passfile.toLocalFile().toStdString());

    if (file.is_open()) {
        QString data(doc.toJson(QJsonDocument::JsonFormat::Compact));

        file.write(data.toStdString().c_str(), data.size());
        file.close();
    }
    //qDebug() << doc.toJson(QJsonDocument::JsonFormat::Compact);
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
