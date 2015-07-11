/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    function parseWpaCliOutput(output) {
        var wifiInfo = []
        var networks = output.split('\n')
        networks = networks.slice(2, networks.length-1)
        for (var index in networks) {
            var parts = networks[index].split('\t')
            wifiInfo[wifiInfo.length] = [parts[1], parts[2], parts[4]]
        }
        updateGraph(wifiInfo)
    }

    function updateGraph(wifiInfo) {
        for (var index in wifiInfo) {
            var channel = calculateChannel(wifiInfo[index][0])
            console.log(wifiInfo[index][0] + " | " + channel)
        }
    }

    function calculateChannel(frequency) {
        switch (parseInt(frequency, 10)) {
        case 2412:
            return 1

        case 2417:
            return 2

        case 2422:
            return 3

        case 2427:
            return 4

        case 2432:
            return 5

        case 2437:
            return 6

        case 2442:
            return 7

        case 2447:
            return 8

        case 2452:
            return 9

        case 2457:
            return 10

        case 2462:
            return 11

        case 2467:
            return 12

        case 2472:
            return 13

        case 2484:
            return 14
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("UI Template")
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
        }
    }

    Connections {
        target: wpaCliHelper
        onCalledWpaCli: parseWpaCliOutput(wpaCliHelper.getWifiInfo())
        onGotScanError: console.log("onGotScanError")
        onGotResultError: console.log("onGotResultError")
    }

    Component.onCompleted: wpaCliHelper.callWpaCli()
}


