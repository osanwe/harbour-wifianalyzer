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
        var wifiInfo = []
        var networks = output.split('\n')
        networks = networks.slice(2, networks.length-1)
        for (var index in networks) {
            var parts = networks[index].split('\t')
            wifiInfo[wifiInfo.length] = [parts[1], parts[2], parts[4]]
        }
        mWifiInfo = wifiInfo
        graph.requestPaint()
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
            return 0

        case 2417:
            return 1

        case 2422:
            return 2

        case 2427:
            return 3

        case 2432:
            return 4

        case 2437:
            return 5

        case 2442:
            return 6

        case 2447:
            return 7

        case 2452:
            return 8

        case 2457:
            return 9

        case 2462:
            return 10

        case 2467:
            return 11

        case 2472:
            return 12

        case 2484:
            return 13
        }
    }

    function calculateChannelsPositions(width) {
        var step = width / 94

        var channels = []
        channels[0]  = (11 * step)
        channels[1]  = (16 * step)
        channels[2]  = (21 * step)
        channels[3]  = (26 * step)
        channels[4]  = (31 * step)
        channels[5]  = (36 * step)
        channels[6]  = (41 * step)
        channels[7]  = (46 * step)
        channels[8]  = (51 * step)
        channels[9]  = (56 * step)
        channels[10] = (61 * step)
        channels[11] = (66 * step)
        channels[12] = (71 * step)
        channels[13] = (83 * step)

        return channels
    }

    function calculateSignalLevelsPositions(height) {
        var step = height / 8

        var levels = []
        levels[0] = step + Theme.paddingLarge
        levels[1] = (2 * step) + Theme.paddingLarge
        levels[2] = (3 * step) + Theme.paddingLarge
        levels[3] = (4 * step) + Theme.paddingLarge
        levels[4] = (5 * step) + Theme.paddingLarge
        levels[5] = (6 * step) + Theme.paddingLarge
        levels[6] = (7 * step) + Theme.paddingLarge

        return levels
    }

    function calculateCurrentSignalLevelPosition(height, level) {
        return height / 80 * (Math.abs(level) - 20)
    }

    function calculateBoundsPositionForChannel(width, channel) {
        var step = width / 94
        var left
        var right

        switch (channel) {
        case 0:
            left = 0
            right = 22 * step
            break

        case 1:
            left = 3 * step
            right = 27 * step
            break

        case 2:
            left = 10 * step
            right = 32 * step
            break

        case 3:
            left = 15 * step
            right = 37 * step
            break

        case 4:
            left = 20 * step
            right = 42 * step
            break

        case 5:
            left = 25 * step
            right = 47 * step
            break

        case 6:
            left = 30 * step
            right = 52 * step
            break

        case 7:
            left = 35 * step
            right = 57 * step
            break

        case 8:
            left = 40 * step
            right = 62 * step
            break

        case 9:
            left = 50 * step
            right = 67 * step
            break

        case 10:
            left = 50 * step
            right = 72 * step
            break

        case 11:
            left = 55 * step
            right = 77 * step
            break

        case 12:
            left = 60 * step
            right = 82 * step
            break

        case 13:
            left = 72 * step
            right = 94 * step
            break
        }

        return [left, right]
    }

    SilicaFlickable {
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

        Canvas {
            id: graph
            anchors.fill: parent

            onPaint: {
                var width = parent.width - (4.5 * Theme.paddingLarge)
                var height = parent.height - (3 * Theme.paddingLarge)

                var ctx = graph.getContext("2d")
                ctx.clearRect(0, 0, parent.width, parent.height)

                ctx.lineWidth = 3
                ctx.strokeStyle = "gray"
                ctx.fillStyle = "gray"
                ctx.font = "12pt sans-serif"

                ctx.beginPath()
                ctx.moveTo(2.5*Theme.paddingLarge, Theme.paddingLarge)
                ctx.lineTo(parent.width-Theme.paddingLarge, Theme.paddingLarge)
                ctx.lineTo(parent.width-Theme.paddingLarge, parent.height-(2*Theme.paddingLarge))
                ctx.lineTo(2.5*Theme.paddingLarge, parent.height-(2*Theme.paddingLarge))
                ctx.closePath()
                ctx.stroke()

                ctx.lineWidth = 1
                var currChannel = 1
                var channels = calculateChannelsPositions(width)
                for (var channelIndex in channels) {
                    ctx.beginPath()
                    ctx.moveTo(channels[channelIndex]+(2.5*Theme.paddingLarge), Theme.paddingLarge)
                    ctx.lineTo(channels[channelIndex]+(2.5*Theme.paddingLarge), parent.height-(2*Theme.paddingLarge))
                    ctx.closePath()
                    ctx.stroke()

                    var textWidth = ctx.measureText(currChannel).width
                    ctx.fillText(currChannel, channels[channelIndex]+(2.5*Theme.paddingLarge)-(textWidth/2), parent.height-Theme.paddingLarge)
                    currChannel += 1
                }

                var currLevel = 30
                var levels = calculateSignalLevelsPositions(height)
                for (var levelsIndex in levels) {
                    ctx.beginPath()
                    ctx.moveTo(2.5*Theme.paddingLarge, levels[levelsIndex])
                    ctx.lineTo(parent.width-Theme.paddingLarge, levels[levelsIndex])
                    ctx.closePath()
                    ctx.stroke()

//                    console.log("level -" + currLevel + " = " + levels[levelsIndex])
                    ctx.fillText("-"+currLevel, Theme.paddingLarge, levels[levelsIndex])
                    currLevel += 10
                }

                if (mWifiInfo.length === 0) return

                var strokeColors = ["rgb(255,   0,   0)",
                                    "rgb(128, 128,   0)",
                                    "rgb(255, 255,   0)",
                                    "rgb(  0, 128,   0)",
                                    "rgb(  0, 255,   0)",
                                    "rgb(  0, 128, 128)",
                                    "rgb(  0, 255, 255)",
                                    "rgb(  0,   0, 128)",
                                    "rgb(  0,   0, 255)",
                                    "rgb(128,   0, 128)",
                                    "rgb(255,   0, 255)",
                                    "rgb(128,   0,   0)"]
                var fillColors = ["rgba(255,   0,   0, 0.33)",
                                  "rgba(128, 128,   0, 0.33)",
                                  "rgba(255, 255,   0, 0.33)",
                                  "rgba(  0, 128,   0, 0.33)",
                                  "rgba(  0, 255,   0, 0.33)",
                                  "rgba(  0, 128, 128, 0.33)",
                                  "rgba(  0, 255, 255, 0.33)",
                                  "rgba(  0,   0, 128, 0.33)",
                                  "rgba(  0,   0, 255, 0.33)",
                                  "rgba(128,   0, 128, 0.33)",
                                  "rgba(255,   0, 255, 0.33)",
                                  "rgba(128,   0,   0, 0.33)"]

                ctx.lineWidth = 2
                for (var networkIndex in mWifiInfo) {
                    ctx.strokeStyle = strokeColors[networkIndex % strokeColors.length]
                    ctx.fillStyle = fillColors[networkIndex % fillColors.length]

                    var channel = calculateChannel(mWifiInfo[networkIndex][0])
                    var levelPosition = calculateCurrentSignalLevelPosition(height, mWifiInfo[networkIndex][1])
                    var bounds = calculateBoundsPositionForChannel(width, channel)
//                    console.log((levelPosition+Theme.paddingLarge) + " | " + mWifiInfo[networkIndex][1])

                    var cpX = 2*(channels[channel]+(2.5*Theme.paddingLarge)) - (bounds[0]+(2.5*Theme.paddingLarge))/2 - (bounds[1]+(2.5*Theme.paddingLarge))/2
                    var cpY = 2*(levelPosition+Theme.paddingLarge) - (parent.height-(2*Theme.paddingLarge))/2 - (parent.height-(2*Theme.paddingLarge))/2

                    ctx.beginPath()
                    ctx.moveTo(bounds[0]+(2.5*Theme.paddingLarge), parent.height-(2*Theme.paddingLarge))
                    ctx.quadraticCurveTo(cpX, cpY, bounds[1]+(2.5*Theme.paddingLarge), parent.height-(2*Theme.paddingLarge))
                    ctx.closePath()
                    ctx.stroke()
                    ctx.fill()

                    ctx.fillStyle = ctx.strokeStyle
                    var textWidth = ctx.measureText(mWifiInfo[networkIndex][2]).width
                    ctx.fillText(mWifiInfo[networkIndex][2], channels[channel]+(2.5*Theme.paddingLarge)-(textWidth/2), levelPosition+Theme.paddingLarge)
                }
            }
        }
    }

    Connections {
        target: wpaCliHelper
        onCalledWpaCli: parseWpaCliOutput(wpaCliHelper.getWifiInfo())
        onGotScanError: console.log("onGotScanError")
        onGotResultError: console.log("onGotResultError")
    }

    onOrientationChanged: graph.requestPaint()
//    Component.onCompleted: wpaCliHelper.callWpaCli()
}


