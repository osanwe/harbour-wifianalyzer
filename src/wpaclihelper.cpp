#include "wpaclihelper.h"

#include <stdio.h>

WpaCliHelper::WpaCliHelper(QObject *parent) :
    QObject(parent)
{
}

WpaCliHelper::~WpaCliHelper()
{
}


void WpaCliHelper::callWpaCli() {
    QProcess process;

    process.start("/bin/bash -c \"echo zxywfjmhn | devel-su wpa_cli scan\"");
    if (!process.waitForFinished()) {
        emit gotScanError();
        return;
    }
    mWifiInfo = process.readAll();

    process.start("/bin/bash -c \"echo zxywfjmhn | devel-su wpa_cli scan_results\"");
    if (!process.waitForFinished()) {
        emit gotResultError();
        return;
    }
    mWifiInfo = process.readAll();

    emit calledWpaCli();
}

QString WpaCliHelper::getWifiInfo() {
    return mWifiInfo;
}
