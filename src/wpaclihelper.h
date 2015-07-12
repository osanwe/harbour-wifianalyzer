/*
  Copyright (C) 2015 Petr Vytovtov
  Contact: Petr Vytovtov <osanwe@protonmail.ch>
  All rights reserved.

  This file is part of WiFi Analyzer for Sailfish OS.

  WiFi Analyzer is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  WiFi Analyzer is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with WiFi Analyzer.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef WPACLIHELPER_H
#define WPACLIHELPER_H

#include <QObject>
#include <QProcess>

class WpaCliHelper : public QObject
{
    Q_OBJECT

public:
    explicit WpaCliHelper(QObject *parent = 0);
    virtual ~WpaCliHelper();

signals:
    void calledWpaCli();
    void gotScanError();
    void gotResultError();

public slots:
    void callWpaCli(QString password);
    QString getWifiInfo();

private:
    QString mWifiInfo;

};

#endif // WPACLIHELPER_H
