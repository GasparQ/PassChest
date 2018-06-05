#ifndef PASSWORD_H
#define PASSWORD_H

#include <QObject>
#include <QString>

#include <QJsonValue>
#include <QJsonObject>

class Password : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint32 id READ id)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

public:
    Password();

public:
    qint32 id() const;
    QString &name();
    QString &description();

public:
    void setId(quint32 id);
    void setName(QString const &value);
    void setDescription(QString const &value);
    Q_INVOKABLE void setPassword(QString const &value);
    Q_INVOKABLE bool hasPassword() const;

public:
    Q_INVOKABLE void copyToClipboard() const;

signals:
    void nameChanged(QString const &name);
    void descriptionChanged(QString const &description);

public:
    operator QJsonValue() const
    {
        QJsonObject obj;

        obj.insert("name", QJsonValue(m_name));
        obj.insert("description", QJsonValue(m_description));
        obj.insert("password", QJsonValue(m_pass));

        return QJsonValue(obj);
    }

private:
    quint32 m_id;
    QString m_name;
    QString m_description;
    QString m_pass;
};

#endif // PASSWORD_H
