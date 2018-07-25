#include <QApplication>
#include <QClipboard>

#include "password.h"

Password::Password(quint32 id) :
    QObject(nullptr),
    m_id(id),
    m_name(),
    m_description(),
    m_pass()
{

}

qint32 Password::id() const
{
    return static_cast<qint32>(m_id);
}

QString &Password::name()
{
    return m_name;
}

QString &Password::description()
{
    return m_description;
}

QString &Password::password()
{
    return m_pass;
}

void Password::setName(const QString &value)
{
    if (m_name == value) return;

    m_name = value;
    emit nameChanged(m_name);
}

void Password::setDescription(const QString &value)
{
    if (m_description == value) return;

    m_description = value;
    emit descriptionChanged(m_description);
}

void Password::setPassword(const QString &value)
{
    m_pass = value;
}

bool Password::hasPassword() const
{
    return !m_pass.isEmpty();
}

void Password::copyToClipboard() const
{
    QApplication::clipboard()->setText(m_pass);
}

Password::operator QJsonValue() const
{
    QJsonObject obj;

    obj.insert("name", QJsonValue(m_name));
    obj.insert("description", QJsonValue(m_description));
    obj.insert("password", QJsonValue(m_pass));

    return QJsonValue(obj);
}
