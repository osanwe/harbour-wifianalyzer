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

    Canvas {
        id: graph
        anchors.fill: parent

        onPaint: {
            var width = Screen.width - (4.5 * Theme.paddingLarge)
            var height = Screen.height - (3 * Theme.paddingLarge)

            var ctx = graph.getContext("2d")
            ctx.lineWidth = 3
            ctx.strokeStyle = "gray"
            ctx.fillStyle = "gray"
            ctx.font = "12pt sans-serif"

            ctx.beginPath()
            ctx.moveTo(2.5*Theme.paddingLarge, Theme.paddingLarge)
            ctx.lineTo(Screen.width-Theme.paddingLarge, Theme.paddingLarge)
            ctx.lineTo(Screen.width-Theme.paddingLarge, Screen.height-(2*Theme.paddingLarge))
            ctx.lineTo(2.5*Theme.paddingLarge, Screen.height-(2*Theme.paddingLarge))
            ctx.closePath()
            ctx.stroke()

            ctx.lineWidth = 1
            var currChannel = 1
            var channels = calculateChannelsPositions(width)
            for (var channelIndex in channels) {
                ctx.beginPath()
                ctx.moveTo(channels[channelIndex]+(2.5*Theme.paddingLarge), Theme.paddingLarge)
                ctx.lineTo(channels[channelIndex]+(2.5*Theme.paddingLarge), Screen.height-(2*Theme.paddingLarge))
                ctx.closePath()
                ctx.stroke()

                ctx.fillText(currChannel, channels[channelIndex]+(2.5*Theme.paddingLarge), Screen.height-Theme.paddingLarge)
                currChannel += 1
            }

            var currLevel = 30
            var levels = calculateSignalLevelsPositions(height)
            for (var levelsIndex in levels) {
                ctx.beginPath()
                ctx.moveTo(2.5*Theme.paddingLarge, levels[levelsIndex])
                ctx.lineTo(Screen.width-Theme.paddingLarge, levels[levelsIndex])
                ctx.closePath()
                ctx.stroke()

                ctx.fillText("-"+currLevel, Theme.paddingLarge, levels[levelsIndex])
                currLevel += 10
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


