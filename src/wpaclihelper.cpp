#include "wpaclihelper.h"

#include <stdio.h>

WpaCliHelper::WpaCliHelper(QObject *parent) :
    QObject(parent)
{
}

WpaCliHelper::~WpaCliHelper()
{
}


WpaCliHelper::callWpaCli() {
    QProcess process;

    process.start("pkexec wpa_cli scan");
    if (!process.waitForFinished()) {
        return;
    }
    mWifiInfo = process.readAll();
    printf(mWifiInfo);

    process.start("pkexec wpa_cli scan_results");
    if (!process.waitForFinished()) {
        return;
    }
    mWifiInfo = process.readAll();
    printf(mWifiInfo);

    emit gotWifiInfo();
}

QString WpaCliHelper::getWifiInfo() {
    return mWifiInfo;
}
