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

Dialog {
    id: passwordPage

    property bool isHide: true

    Column {
        anchors.fill: parent

        DialogHeader {
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        Label {
            x: Theme.horizontalPageMargin
            anchors.left: parent.left
            anchors.right: parent.right
            text: qsTr("Your password for devel-su will be saved only for this session. You have to type it after each applicaton starting. Your devel-su password is required for starting `wpa_cli` util.")
            wrapMode: Text.Wrap
        }

        Row {
            x: Theme.horizontalPageMargin
            anchors.left: parent.left
            anchors.right: parent.right

            TextField {
                id: passwordField
                width: parent.width - changePasswordFieldEchoMode.width
                placeholderText: qsTr("Type devel-su password:")
                label: qsTr("Your devel-su password")
                echoMode: isHide ? TextInput.Password : TextInput.Normal
                focus: true
            }

            IconButton {
                id: changePasswordFieldEchoMode
                icon.source: isHide ? "image://theme/icon-m-dialpad" : "image://theme/icon-m-device-lock"
                onClicked: isHide = !isHide
            }
        }
    }

    onAccepted: rootApp.password = passwordField.text
}
