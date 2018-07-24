#ifndef PASSWORDMANAGER_H
#define PASSWORDMANAGER_H

#include <stack>

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
    Q_PROPERTY(bool canUndo READ canUndo NOTIFY canUndoChanged)
    Q_PROPERTY(bool canRedo READ canRedo NOTIFY canRedoChanged)

private:
    static const QString LAST_FILE;

private:
    struct Command
    {
        using Action = std::function<void()>;

        Action undo;
        Action redo;
    };

public:
    PasswordManager();

public:
    bool initialize(QString const &applicationPath);

public:
    Q_INVOKABLE bool load(QString const &password);
    Q_INVOKABLE bool save(QString const &password);
    Q_INVOKABLE void reset();
    Q_INVOKABLE void undo();
    Q_INVOKABLE void redo();

public:
    QList<QVariant> passwords() const;
    QString const &filename() const;
    bool isOpen() const;
    bool isSaved() const;
    bool canUndo() const;
    bool canRedo() const;

public:
    void setFilename(QString const &value);
    void setSaved(bool value);

    //edit actions
public:
    Q_INVOKABLE void addPassword(QString name, QString description, QString password);
    Q_INVOKABLE void removePassword(quint32 id);
    Q_INVOKABLE void editPassword(quint32 id, QString name, QString description, QString password);

private:
    Password *newPassword();
    void exec(Command::Action const &redo, Command::Action const &undo);

signals:
    void passwordsChanged(QList<QVariant> const &passwords);
    void loaded(QUrl const &file);
    void saved(QUrl const &file);
    void canUndoChanged(bool value);
    void canRedoChanged(bool value);

private:
    BotanCipher m_cipherer;

private:
    QMap<quint32, Password *>   m_passwords;
    quint32 m_currentId;

private:
    QString m_filename;
    bool m_opened;
    bool m_saved;

private:
    std::stack<Command> m_undoStack;
    std::stack<Command> m_redoStack;
};

#endif // PASSWORDMANAGER_H
