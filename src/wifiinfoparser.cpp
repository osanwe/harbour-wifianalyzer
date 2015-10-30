#include "wifiinfoparser.h"

WifiInfoParser::WifiInfoParser(QObject *parent) :
    QObject(parent)
{
    qDebug() << "WifiInfoParser()";
}

WifiInfoParser::~WifiInfoParser() {
    qDebug() << "~WifiInfoParser()";
}

/**
 * The method parses info about WiFi-networks received from wpa_cli.
 * @param info - wpa_cli output
 */
void WifiInfoParser::parseInfo(QString info) {
    qDebug() << QString("parseInfo(%1)").arg(info);

    wifiInfo.clear();

    QStringList networks = info.split('\n');
    if (networks.length() == 3) {
        networkCount = 0;
        emit parsed(PARSE_COMPLETED_WITH_NO_NETWORKS);
    }

    networkCount = networks.length() - 3;
    for (int i = 0; i < networkCount; i++) {
        QStringList data = networks.at(i+2).split('\t');
        wifiInfo << QVariant::fromValue(
                        (QStringList() << QString::number(calculateChannel(data[1].toInt())) // channel
                                       << data[2] // level
                                       << data[4] // name
                                       << data[0])); // bssid
    }
    emit parsed(PARSE_COMPLETED_CORRECTLY);
}

/**
 * The method returns count of WiFi-networks.
 * @return The count of WiFi networks
 */
int WifiInfoParser::getWifiNetworksCount() {
    qDebug() << "getWifiNetworksCount()";
    return networkCount;
}

/**
 * The methos returns info about WiFi-networks.
 * @return Info about WiFi-networks
 */
QVariantList WifiInfoParser::getWifiInfo() {
    qDebug() << "getWifiInfo()";
    return wifiInfo;
}

/**
 * The method calculate the number of channel.
 * @param frequency - a frequency of current channel
 * @return The number of current channel
 */
int WifiInfoParser::calculateChannel(int frequency) {
    qDebug() << QString("calculateChannel(%1)").arg(frequency);
    switch (frequency) {
    case 2412: return 0;
    case 2417: return 1;
    case 2422: return 2;
    case 2427: return 3;
    case 2432: return 4;
    case 2437: return 5;
    case 2442: return 6;
    case 2447: return 7;
    case 2452: return 8;
    case 2457: return 9;
    case 2462: return 10;
    case 2467: return 11;
    case 2472: return 12;
    case 2484: return 13;
    default: return -1;
    }
}
