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

    ViewPlaceholder {
        enabled: !networksList.powered
        text: qsTr("Please, turn WiFi on")
    }

    SilicaListView {
        id: wifiInfoList

        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("About")
                onClicked: pageContainer.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        model: networksList

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
                        width: parent.width / 2
                        horizontalAlignment: Text.AlignLeft
                        font.bold: true
                        text: modelData.name
                        truncationMode: TruncationMode.Fade
                    }

                    Label {
                        width: parent.width / 4
                        horizontalAlignment: Text.AlignRight
                        text: (calculateChannel(modelData.frequency) + 1) + " ch."
                    }

                    Label {
                        width: parent.width / 4
                        horizontalAlignment: Text.AlignRight
                        text: (modelData.strength - 120) + " dB"
                    }
                }

                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    text: "bssid: " + modelData.bssid
                }

                ProgressBar {
                    width: parent.width
                    minimumValue: 0
                    maximumValue: 100
                    value: modelData.strength
                }
            }
        }
    }
}
