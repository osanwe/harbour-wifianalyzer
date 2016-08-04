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

import "../views"

Page {
    id: graphPage

    allowedOrientations: Orientation.All

    property variant channelsInfo: [11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 83]

    property var strokeColors: ["rgb(255,   0,   0)",
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
    property var fillColors: ["rgba(255,   0,   0, 0.33)",
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

    function calculateChannelsPositions(width) {
        var channels = [];
        var step = (width - Theme.horizontalPageMargin) / 94;
        for (var index in channelsInfo) {
            channels[index] = channelsInfo[index] * step + Theme.horizontalPageMargin;
        }
        return channels;
    }

    function calculateSignalLevelsPositions(height) {
        var levels = [];
        var step = (height - Theme.paddingLarge) / 10;
        for (var index = 0; index < 10; index += 1) {
            levels[index] = index * step + Theme.paddingLarge;
        }
        return levels;
    }

    /**
     * The method calculates Y-coordinate for signal level.
     * @param height - the height of the screen
     * @param level - the signal level of the WiFi-network
     */
    function calculateCurrentSignalLevelPosition(height, level) {
        return height / 100 * Math.abs(level);
    }

    /**
     * The method calculates X-coordinates of WiFi-signal bounds.
     * @param width - the width of the screen
     * @param channel - the number of the channel
     * @return The array with X-coordinates of left and right bounds of the WiFi-signal
     */
    function calculateBoundsPositionForChannel(width, channel) {
        var step = width / 94;
        var left = (channelsInfo[channel] - 11) * step;
        var right = (channelsInfo[channel] + 11) * step;
        return [left, right];
    }

    function drawGraphBounds(context) {
        context.beginPath();
        context.moveTo(2 * Theme.horizontalPageMargin, Theme.paddingLarge);
        context.lineTo(graph.width - Theme.horizontalPageMargin, Theme.paddingLarge);
        context.lineTo(graph.width - Theme.horizontalPageMargin, graph.height - (2 * Theme.paddingLarge));
        context.lineTo(2 * Theme.horizontalPageMargin, graph.height - (2 * Theme.paddingLarge));
        context.closePath();
        context.stroke();
    }

    function drawChannelAxe(context, channelCoord) {
        context.beginPath();
        context.moveTo(channelCoord, Theme.paddingLarge);
        context.lineTo(channelCoord, graph.height - (2 * Theme.paddingLarge));
        context.closePath();
        context.stroke();
    }

    function drawChannelNumber(context, channelIndex, channelCoord) {
        var text = parseInt(channelIndex) + 1;
        var textWidth = context.measureText(text).width;
        context.fillText(text, channelCoord - (textWidth / 2), graph.height - Theme.paddingLarge);
    }

    function drawChannelsAxes(context, channels) {
        context.lineWidth = 1;
        for (var channelIndex in channels) {
            drawChannelAxe(context, channels[channelIndex]);
            drawChannelNumber(context, channelIndex, channels[channelIndex]);
        }
    }

    function drawSignalLevelAxe(context, signalLevelCoord) {
        context.beginPath();
        context.moveTo(2 * Theme.horizontalPageMargin, signalLevelCoord);
        context.lineTo(graph.width - Theme.horizontalPageMargin, signalLevelCoord);
        context.closePath();
        context.stroke();
    }

    function drawSignalLevel(context, signalLevel, signalLevelCoord) {
        if (signalLevel === '0') return;
        var text = '-' + signalLevel + '0';
        var textWidth = context.measureText(text).width;
        context.fillText(text, Theme.horizontalPageMargin - (textWidth / 2), signalLevelCoord);
    }

    function drawSignalLevelsAxes(context, levels) {
        for (var levelIndex in levels) {
            drawSignalLevelAxe(context, levels[levelIndex]);
            drawSignalLevel(context, levelIndex, levels[levelIndex]);
        }
    }

    function drawAxes(context, channels, levels) {
        drawGraphBounds(context);
        drawChannelsAxes(context, channels);
        drawSignalLevelsAxes(context, levels);
    }

    /**
     * The method calculates a current point for the bezier curve.
     * @param channelCoord - X-coordinate of the current channel
     * @param levelPosition - Y-coordinate of the current signal level
     * @param bounds - bounds of the current bezier curve
     * @return The current point coordinates
     */
    function calculateCurrentPoint(channelCoord, levelPosition, bounds) {
        var cpx = 2 * (channelCoord + (2.5 * Theme.paddingLarge)) -
                (bounds[0] + (2.5 * Theme.paddingLarge)) / 2 - (bounds[1] + (2.5 * Theme.paddingLarge)) / 2;
        var cpy = 2 * (levelPosition + Theme.paddingLarge) -
                (parent.height - (2 * Theme.paddingLarge)) / 2 - (parent.height - (2 * Theme.paddingLarge)) / 2;
        return { x: cpx, y: cpy };
    }

    /**
     * The method draws the bezier curve for current WiFi-network.
     * @param context - context for drawing
     * @param channelCoord - X-coordinate for current channel
     * @param levelPosition - Y-coordinate for current signal level
     * @param bounds - bounds of the current bezier curve
     */
    function drawWifiFigure(context, channelCoord, levelPosition, bounds) {
        var cp = calculateCurrentPoint(channelCoord, levelPosition, bounds);
        context.beginPath();
        context.moveTo(bounds[0] + (2.5 * Theme.paddingLarge),
                       parent.height - (2 * Theme.paddingLarge));
        context.quadraticCurveTo(cp.x, cp.y, bounds[1] + (2.5 * Theme.paddingLarge),
                                 parent.height - (2 * Theme.paddingLarge));
        context.closePath();
        context.stroke();
        context.fill();
    }

    /**
     * The method draws the current WiFi-network method.
     * @param context - context for drawing
     * @param wifiInfo - information about current WiFi-network
     * @param channels - the array of channelscoordinates
     * @param levelPosition - Y-coordinate of current signal level
     */
    function drawWifiName(context, wifiInfo, channels, levelPosition) {
        var textWidth = context.measureText(wifiInfo.name).width;
        context.fillText(wifiInfo.name,
                         channels[calculateChannel(wifiInfo.frequency)] + (2.5 * Theme.paddingLarge) - (textWidth / 2),
                         levelPosition + Theme.paddingLarge);
    }

    /**
     * The method draws a figure for each WiFi-network.
     * @param context - context for drawing.
     * @param channels - the array of channels coordinates
     */
    function drawWifiFigures(context, width, height, channels) {
        context.lineWidth = 2;
        for (var networkIndex = 0; networkIndex < networksList.count; ++networkIndex) {
            var levelPosition = calculateCurrentSignalLevelPosition(height, (networksList.get(networkIndex).strength - 120))
            var bounds = calculateBoundsPositionForChannel(width, calculateChannel(networksList.get(networkIndex).frequency))
            context.strokeStyle = strokeColors[networkIndex % strokeColors.length];
            context.fillStyle = fillColors[networkIndex % fillColors.length];
            drawWifiFigure(context, channels[calculateChannel(networksList.get(networkIndex).frequency)], levelPosition, bounds);
            context.fillStyle = context.strokeStyle;
            drawWifiName(context, networksList.get(networkIndex), channels, levelPosition);
        }
    }

    /**
     * The method draw axes and graph view of WiFi-networks.
     * @param width - the width of the screen
     * @param height - the height of the screen
     */
    function drawGraph(width, height) {
        var context = graph.getContext("2d");
        context.clearRect(0, 0, width, height);
        context.lineWidth = 3;
        context.strokeStyle = "gray";
        context.fillStyle = "gray";
        context.font = "12pt sans-serif";

        var channels = calculateChannelsPositions(width);
        var levels = calculateSignalLevelsPositions(height)
        drawAxes(context, channels, levels);

        if (networksList.count === 0) return;
        drawWifiFigures(context, width, height, channels);
    }

    ViewPlaceholder {
        enabled: !networksList.powered
        text: qsTr("Please, turn WiFi on")
    }

    SilicaFlickable {
        anchors.fill: parent

        TopMenu {
            pageName: "GraphPage.qml"
        }

        Canvas {
            id: graph
            anchors {
                fill: parent
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
                topMargin: Theme.paddingLarge
                bottomMargin: Theme.paddingLarge
            }

            onPaint: drawGraph(width, height)
        }
    }

    Connections {
        target: networksList
        onScanRequestFinished: graph.requestPaint()
    }

    onOrientationChanged: graph.requestPaint()

    onStatusChanged: {
        if (status === PageStatus.Active && pageContainer.depth === 1 &&
                (!settings.value("defaultPage") || settings.value("defaultPage") === "GraphPage.qml"))
            pageContainer.pushAttached(Qt.resolvedUrl("ListPage.qml"))
    }
}
