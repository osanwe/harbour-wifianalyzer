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

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: graphPage
    allowedOrientations: Orientation.All

    property variant mWifiInfo: []

    function parseWpaCliOutput(output) {
        console.log(output)

        var wifiInfo = []
        var networks = output.split('\n')
        networks = networks.slice(2, networks.length-1)
        for (var index in networks) {
            var parts = networks[index].split('\t')
            wifiInfo[wifiInfo.length] = [parts[1], parts[2], parts[4]]
        }
        mWifiInfo = wifiInfo
    }

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("About")
                onClicked: pageContainer.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Set password")
                onClicked: pageContainer.push(Qt.resolvedUrl("PasswordPage.qml"))
            }
        }

        PushUpMenu {

            MenuItem {
                text: qsTr("Graph view")
                onClicked: pageContainer.replace(Qt.resolvedUrl("GraphPage.qml"))
            }
        }

        model: 10

        delegate: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingLarge
            anchors.rightMargin: Theme.paddingLarge
            height: Theme.itemSizeMedium

            Column {
                anchors.fill: parent
                anchors.topMargin: Theme.paddingLarge
                anchors.bottomMargin: Theme.paddingLarge

                Row {
                    width: parent.width

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignLeft
                        text: "by DC Osanve"
                    }

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignRight
                        text: "6 ch."
                    }

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignRight
                        text: "-60 dB"
                    }
                }

                ProgressBar {
                    width: parent.width
                    minimumValue: -100
                    maximumValue: 0
                    value: -60
                }
            }
        }
    }

    Connections {
        target: wpaCliHelper
        onCalledWpaCli: parseWpaCliOutput(wpaCliHelper.getWifiInfo())
        onGotAuthError: console.log("onGotAuthError")
        onGotResultError: console.log("onGotResultError")
        onGotScanError: console.log("onGotScanError")
    }
}
