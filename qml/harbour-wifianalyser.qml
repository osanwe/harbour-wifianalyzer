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

import QtQuick 2.2
import Sailfish.Silica 1.0
;import MeeGo.Connman 0.2

import "pages"

ApplicationWindow {
    id: rootApp

    /**
     * The method calculates the WiFi-network channel.
     * @param frequency - the frecuency of current WiFi-network
     * @return The channel number of current WiFi-network
     */
    function calculateChannel(frequency) {
        var channel = (frequency - 2412) / 5;
        return channel > 12 ? 13 : channel;
    }

    initialPage: settings.value("defaultPage") ?
                     Qt.createComponent(Qt.resolvedUrl("pages/" + settings.value("defaultPage"))) :
                     Qt.createComponent(Qt.resolvedUrl("pages/GraphPage.qml"))
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
