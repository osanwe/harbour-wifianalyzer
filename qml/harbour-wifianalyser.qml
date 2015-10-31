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

import MeeGo.Connman 0.2
import QtQuick 2.0
import Sailfish.Silica 1.0

import "pages"

ApplicationWindow {
    id: rootApp

    /**
     * The method calculates the WiFi-network channel.
     * @param frequency - the frecuency of current WiFi-network
     * @return The channel number of current WiFi-network
     */
    function calculateChannel(frequency) {
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

    property string password: ""
    property string oldPassword: ""

    initialPage: Component { GraphPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Timer {
        id: updateTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networksList.requestScan()
    }

    // More info:
    // https://git.merproject.org/mer-core/libconnman-qt/blob/master/plugin/technologymodel.h
    // https://git.merproject.org/mer-core/libconnman-qt/blob/master/libconnman-qt/networkservice.h
    TechnologyModel {
        id: networksList
        name: "wifi"
    }
}
