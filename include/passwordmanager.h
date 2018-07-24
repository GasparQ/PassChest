#ifndef PASSWORDMANAGER_H
#define PASSWORDMANAGER_H

#include <QDebug>
#include <QObject>
#include <QList>
#include <QSettings>

#include "password.h"
#include "botancipher.h"

class PasswordManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QVariant> passwords READ passwords NOTIFY passwordsChanged)
    Q_PROPERTY(QString filename READ filename WRITE setFilename)
    Q_PROPERTY(bool isOpen READ isOpen)
    Q_PROPERTY(bool isSaved READ isSaved WRITE setSaved)

private:
    static const QString LAST_FILE;

public:
    PasswordManager();

public:
    bool initialize(QString const &applicationPath);

public:
    Q_INVOKABLE bool load(QString const &password);
    Q_INVOKABLE bool save(QString const &password);
    Q_INVOKABLE void reset();

public:
    QList<QVariant> passwords() const;
    QString const &filename() const;
    bool isOpen() const;
    bool isSaved() const;

public:
    void setFilename(QString const &value);
    void setSaved(bool value);

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
    QString m_filename;
    bool m_opened;
    bool m_saved;
};

#endif // PASSWORDMANAGER_H
