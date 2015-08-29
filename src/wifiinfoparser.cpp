#include "wifiinfoparser.h"

WifiInfoParser::WifiInfoParser(QObject *parent) :
    QObject(parent)
{
}

WifiInfoParser::~WifiInfoParser()
{
}

void WifiInfoParser::parseInfo(QString info) {
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
                        (QStringList() << QString::number(calculateChannel(data[1].toInt()))
                                       << data[2]
                                       << data[4]));
    }
    emit parsed(PARSE_COMPLETED_CORRECTLY);
}

int WifiInfoParser::getWifiNetworksCount() {
    return networkCount;
}

QVariantList WifiInfoParser::getWifiInfo() {
    return wifiInfo;
}

int WifiInfoParser::calculateChannel(int frequency) {
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
