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

Page {
    id: aboutPage

    property var model: [
        { aboutItemText: qsTr("The simple tool for WiFi networks analyzing distributed under the terms of the GNU GPLv3.") },
        { aboutItemText: qsTr("This app uses icons by") + " <a href=\"http://www.flaticon.com/authors/rami-mcmin\">Rami McMin</a>." },
        { aboutItemText: qsTr("You can connect with an author, improve the app or donate:") },
        { aboutItemText: "<a href=\"https://github.com/osanwe/harbour-wifianalyzer\">GitHub</a>" },
        { aboutItemText: "<a href=\"https://twitter.com/Osanwe\">Ósanwe</a>" },
        { aboutItemText: "<a href=\"https://flattr.com/submit/auto?user_id=osanwe&url=https://github.com/osanwe/harbour-wifianalyzer&title=WiFi%20Analyzer\">Flattr</a>" },
        { aboutItemText: "<br>" + qsTr("Localization") },
        { aboutItemText: qsTr("Swedish") + ": <a href=\"https://github.com/eson57\">Åke Engelbrektson</a>" },
        { aboutItemText: qsTr("Czech") + ": <a href=\"https://github.com/RikudouSage\">Rikudou Sennin</a>" },
        { aboutItemText: qsTr("French") + ": <a href=\"https://github.com/Quent-in\">Rasher</a>" }
    ]

    SilicaListView {
        anchors.fill: parent

        model: aboutPage.model

        header: PageHeader {
            title: "WiFi Analyser v2.1.0"
        }

        delegate: Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - Theme.paddingLarge * 2
            height: aboutItem.height + Theme.paddingMedium

            property var item: model.modelData ? model.modelData : model

            Label {
                id: aboutItem
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: index > 2 ? Text.AlignHCenter : Text.AlignLeft
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                wrapMode: TextEdit.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                text: item.aboutItemText
            }
        }

        VerticalScrollDecorator {}
    }
}
