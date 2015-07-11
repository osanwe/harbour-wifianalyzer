#include "wpaclihelper.h"

#include <stdio.h>

WpaCliHelper::WpaCliHelper(QObject *parent) :
    QObject(parent)
{
}

WpaCliHelper::~WpaCliHelper()
{
}


void WpaCliHelper::callWpaCli(QString password) {
    QProcess process;

    process.start(QString("/bin/bash -c \"echo %1 | devel-su wpa_cli scan\"").arg((password)));
    if (!process.waitForFinished()) {
        emit gotScanError();
        return;
    }
    mWifiInfo = process.readAll();

    process.start(QString("/bin/bash -c \"echo %1 | devel-su wpa_cli scan_results\"").arg((password)));
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
