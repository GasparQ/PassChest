#include <QFileInfo>
#include <QDebug>

#include "botancipher.h"

const QString BotanCipher::BOTAN_CLIENT("botan-cli.exe");
const QString BotanCipher::BOTAN_DLL("botan.dll");

bool BotanCipher::initialize(const QString &applicationPath)
{
    QString progPath = applicationPath + "/" + BOTAN_CLIENT;
    QString dllPath = applicationPath + "/" + BOTAN_DLL;

    if (!QFileInfo::exists(progPath) && !QFile::copy(":/binaries/" + BOTAN_CLIENT, progPath))
    {
        qWarning() << "Copy failed: Unable to copy "<< BOTAN_CLIENT << " to " << progPath;
        return false;
    }

    if (!QFileInfo::exists(dllPath) && !QFile::copy(":/binaries/" + BOTAN_DLL, dllPath))
    {
        qWarning() << "Copy failed: Unable to copy " << BOTAN_DLL << " to " << dllPath;
        return false;
    }

    m_botanClient = progPath;
    return true;
}

bool BotanCipher::encrypt(const QByteArray &input, QByteArray &output, QString const &password)
{
    QString key, salt;

    if (!getKeyAndSaltFromPassword(password, key, salt))
    {
        return false;
    }

    return launchBotanClient({
                                 "encryption",
                                 "--mode=aes-256-cfb",
                                 "--key=" + key,
                                 "--iv=" + salt
                            }, input, output);
}

bool BotanCipher::decrypt(const QByteArray &input, QByteArray &output, QString const &password)
{
    QString key, salt;

    if (!getKeyAndSaltFromPassword(password, key, salt))
    {
        return false;
    }

    return launchBotanClient({
                                 "encryption",
                                 "--decrypt",
                                 "--mode=aes-256-cfb",
                                 "--key=" + key,
                                 "--iv=" + salt
                             }, input, output);
}

bool BotanCipher::hash(const QString &password, QString &hash)
{
    QByteArray data;

    if (!launchBotanClient({ "hash" }, password.toLatin1(), data))
        return false;
    hash = QString::fromLatin1(data).mid(0, 64);
    return true;
}

bool BotanCipher::launchBotanClient(const QStringList &arguments, QByteArray const &input, QByteArray &output)
{
    QProcess botanProcess;

    botanProcess.setProgram(m_botanClient);
    botanProcess.setArguments(arguments);
    botanProcess.start();
    if (botanProcess.waitForStarted())
    {
        botanProcess.write(input);
        botanProcess.closeWriteChannel();
        botanProcess.waitForFinished();
        if (botanProcess.exitCode() != 0)
        {
            qWarning() << "Error " << botanProcess.exitCode() << ": " << botanProcess.readAllStandardError();
            return false;;
        }
        output = botanProcess.readAll();
        return true;
    }
    qWarning() << "Error: " << botanProcess.errorString();
    return false;
}

bool BotanCipher::getKeyAndSaltFromPassword(const QString &password, QString &key, QString &salt)
{
    QString passhash;

    if (!hash(password, passhash))
    {
        return false;
    }

    key = passhash;

    for (int i = 0; i < 64; i += 4) {
        salt += QString::number(static_cast<int>(key[i].toLatin1()), 16);
    }

    return true;
}
