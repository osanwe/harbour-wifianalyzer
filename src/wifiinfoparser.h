#ifndef WIFIINFOPARSER_H
#define WIFIINFOPARSER_H

#include <QList>
#include <QObject>
#include <QStringList>
#include <QVariant>
#include <QVariantList>

class WifiInfoParser : public QObject
{
    Q_OBJECT

public:
    explicit WifiInfoParser(QObject *parent = 0);
    virtual ~WifiInfoParser();

signals:
    void parsed(int exitCode);

public slots:
    void parseInfo(QString info);
    int getWifiNetworksCount();
    QVariantList getWifiInfo();

private:
    static const int PARSE_COMPLETED_CORRECTLY = 0;
    static const int PARSE_COMPLETED_WITH_NO_NETWORKS = 1;

    int calculateChannel(int frequency);

    int networkCount;
    QVariantList wifiInfo;
};

#endif // WIFIINFOPARSER_H
