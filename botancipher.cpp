#include <QFileInfo>
#include <QDebug>

#include "botancipher.h"

const QString BotanCipher::BOTAN_CLIENT("botan-cli.exe");
const QString BotanCipher::BOTAN_DLL("botan.dll");

bool BotanCipher::initialize(const QString &applicationPath)
{
    QString progPath = applicationPath + "/" + BOTAN_CLIENT;
    QString dllPath = applicationPath + "/" + BOTAN_DLL;

    if (!QFileInfo::exists(progPath) && !QFile::copy(":/ressources/binaries/" + BOTAN_CLIENT, progPath))
    {
        qWarning() << "Copy failed: Unable to copy "<< BOTAN_CLIENT << " to " << progPath;
        return false;
    }

    if (!QFileInfo::exists(dllPath) && !QFile::copy(":/ressources/binaries/" + BOTAN_DLL, dllPath))
    {
        qWarning() << "Copy failed: Unable to copy " << BOTAN_DLL << " to " << dllPath;
        return false;
    }

    m_botanClient = progPath;
    return true;
}

bool BotanCipher::encrypt(const QByteArray &input, QByteArray &output, QString const &password, QString const &salt)
{
    Q_UNUSED(password)
    Q_UNUSED(salt)

    return launchBotanClient({
                                 "encryption",
                                 "--mode=aes-256-cfb",
                                 "--key=0000000000000000000000000000000000000000000000000000000000000000",
                                 "--iv=00000000000000000000000000000000"
                            }, input, output);
}

bool BotanCipher::decrypt(const QByteArray &input, QByteArray &output, QString const &password, QString const &salt)
{
    Q_UNUSED(password)
    Q_UNUSED(salt)

    return launchBotanClient({
                                 "encryption",
                                 "--decrypt",
                                 "--mode=aes-256-cfb",
                                 "--key=0000000000000000000000000000000000000000000000000000000000000000",
                                 "--iv=00000000000000000000000000000000"
                            }, input, output);
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
