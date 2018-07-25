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
        m_passwords[toadd->id()] = toadd;
    }
    m_opened = true;
    m_saved = true;
    emit loaded(m_filename);
    file.close();
    emit passwordsChanged(passwords());
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

void PasswordManager::undo()
{
    if (canUndo())
    {
        m_undoStack.top().undo();
        m_redoStack.push(m_undoStack.top());
        m_undoStack.pop();
        emit canRedoChanged(true);
        if (!canUndo())
            emit canUndoChanged(false);
    }
}

void PasswordManager::redo()
{
    if (canRedo())
    {
        m_redoStack.top().redo();
        m_undoStack.push(m_redoStack.top());
        m_redoStack.pop();
        emit canUndoChanged(true);
        if (!canRedo())
            emit canRedoChanged(false);
    }
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

bool PasswordManager::canUndo() const
{
    return !m_undoStack.empty();
}

bool PasswordManager::canRedo() const
{
    return !m_redoStack.empty();
}

void PasswordManager::setFilename(const QString &value)
{
    m_filename = value;
}

void PasswordManager::setSaved(bool value)
{
    m_saved = value;
}

void PasswordManager::addPassword(QString name, QString description, QString password)
{
    Password *pass = newPassword();

    pass->setName(name);
    pass->setDescription(description);
    pass->setPassword(password);
    exec([this, pass]() {
        m_passwords[pass->id()] = pass;
        m_saved = false;
        emit passwordsChanged(passwords());
    }, [this, pass]() {
        m_passwords.remove(pass->id());
        m_saved = false;
        emit passwordsChanged(passwords());
    });
}

void PasswordManager::removePassword(quint32 id)
{
    Password *pass = m_passwords[id];

    exec([this, id]() {
        m_passwords.remove(id);
        m_saved = false;
        emit passwordsChanged(passwords());
    }, [this, pass]() {
        m_passwords[pass->id()] = pass;
        m_saved = false;
        emit passwordsChanged(passwords());
    });
}

void PasswordManager::editPassword(quint32 id, QString name, QString description, QString password)
{
    Password *pass = m_passwords[id];
    QString lastName = pass->name(), lastDescription = pass->description(), lastPassword = pass->password();

    exec([this, pass, name, description, password]() {
        pass->setName(name);
        pass->setDescription(description);
        if (!password.isEmpty())
            pass->setPassword(password);
    }, [this, pass, lastName, lastDescription, lastPassword]() {
        pass->setName(lastName);
        pass->setDescription(lastDescription);
        pass->setPassword(lastPassword);
    });
}

Password *PasswordManager::newPassword()
{
    return new Password(m_currentId++);
}

void PasswordManager::exec(const PasswordManager::Command::Action &redo, const PasswordManager::Command::Action &undo)
{
    redo();
    m_undoStack.push(Command { undo, redo });
    while (!m_redoStack.empty()) m_redoStack.pop();
    emit canUndoChanged(true);
    emit canRedoChanged(false);
}
