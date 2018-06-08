#ifndef BOTANCIPHER_H
#define BOTANCIPHER_H

#include <QProcess>

class BotanCipher
{
private:
    static const QString BOTAN_CLIENT;
    static const QString BOTAN_DLL;

public:
    BotanCipher() = default;

public:
    bool initialize(QString const &applicationPath);

public:
    bool encrypt(QByteArray const &input, QByteArray &output, QString const &password, QString const &salt);
    bool decrypt(QByteArray const &input, QByteArray &output, QString const &password, QString const &salt);

private:
    bool launchBotanClient(QStringList const &arguments, QByteArray const &input, QByteArray &output);

private:
    QString m_botanClient;
};

#endif // BOTANCIPHER_H
