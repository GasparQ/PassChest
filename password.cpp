#include <QApplication>
#include <QClipboard>

#include "password.h"

Password::Password() :
    m_id(static_cast<quint32>(-1)),
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

void Password::setId(quint32 id)
{
    m_id = id;
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
