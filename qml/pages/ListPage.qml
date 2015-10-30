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

    /**
     * The method forms the list view with WiFi-networks info.
     * @param networks - the array with WiFi-networks info
     */
    function formWifiInfoList(networks) {
        console.log('formWifiInfoList(' + networks + ')');
        wifiInfoList.model.clear();
        for (var index in networks) {
            var wifiInfo = { channel: parseInt(networks[index][0]) + 1,
                             level:   networks[index][1],
                             name:    networks[index][2],
                             bssid:   networks[index][3] };
            wifiInfoList.model.append(wifiInfo);
        }
    }

    SilicaListView {
        id: wifiInfoList

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

        model: ListModel {}

        delegate: Item {
            width: parent.width
            height: Theme.itemSizeHuge

            Column {
                anchors.fill: parent
                anchors.topMargin: Theme.paddingLarge
                anchors.bottomMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                anchors.leftMargin: Theme.paddingLarge

                Row {
                    anchors.right: parent.right
                    anchors.left: parent.left

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignLeft
                        font.bold: true
                        text: name
                    }

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignRight
                        text: channel + " ch."
                    }

                    Label {
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignRight
                        text: level + " dB"
                    }
                }

                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    text: "bssid: " + bssid
                }

                ProgressBar {
                    width: parent.width
                    minimumValue: -100
                    maximumValue: 0
                    value: level
                }
            }
        }
    }

    Connections {
        target: wpaCliHelper
        onCalledWpaCli: wifiInfoParser.parseInfo(wpaCliHelper.getWifiInfo())
        onGotAuthError: console.log("onGotAuthError")
        onGotResultError: console.log("onGotResultError")
        onGotScanError: console.log("onGotScanError")
    }

    Connections {
        target: wifiInfoParser
        onParsed: if (exitCode === 0) formWifiInfoList(wifiInfoParser.getWifiInfo())
    }
}
