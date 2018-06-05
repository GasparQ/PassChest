#ifndef PASSWORD_H
#define PASSWORD_H

#include <QObject>
#include <QString>

#include <QJsonValue>
#include <QJsonObject>

class Password : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

public:
    Password();

public:
    QString &name();
    QString &description();

public:
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
    QString m_name;
    QString m_description;
    QString m_pass;
};

#endif // PASSWORD_H
