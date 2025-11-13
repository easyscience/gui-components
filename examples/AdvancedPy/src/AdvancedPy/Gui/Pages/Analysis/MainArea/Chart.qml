// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtGraphs

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements

import Gui.Globals as Globals


Rectangle {

    // graph
    GraphsView {

        id: graph
        anchors.fill: parent

        marginTop: EaStyle.Sizes.fontPixelSize * 2
        marginBottom: EaStyle.Sizes.fontPixelSize * 2
        marginLeft: EaStyle.Sizes.fontPixelSize
        marginRight: EaStyle.Sizes.fontPixelSize * 2

        zoomAreaEnabled: true

        // theme
        theme: GraphsTheme {
            backgroundColor: EaStyle.Colors.chartBackground
            plotAreaBackgroundColor: EaStyle.Colors.chartBackground

            axisX.mainColor: EaStyle.Colors.chartGridLine
            axisX.mainWidth: 0
            //axisX.labelTextColor: EaStyle.Colors.chartLabels

            axisY.mainColor: EaStyle.Colors.chartGridLine
            axisY.mainWidth: 0
            //axisY.labelTextColor: EaStyle.Colors.chartLabels

            gridVisible: true
            grid.mainWidth: 1
            grid.subWidth: 0
            grid.mainColor: EaStyle.Colors.chartGridLine
            grid.subColor: EaStyle.Colors.chartMinorGridLine

            labelFont.family: EaStyle.Fonts.fontFamily
            labelFont.pixelSize: EaStyle.Sizes.fontPixelSize
            labelTextColor: EaStyle.Colors.chartLabels
        }
        // theme

        // axisX
        axisX: ValueAxis {
            //visible: true
            //gridVisible: false
            //subGridVisible: true
            //labelsVisible: true
            //subTickCount: 1

            labelDelegate: TextEdit {
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                bottomPadding: EaStyle.Sizes.fontPixelSize
                color: EaStyle.Colors.chartLabels
            }


            titleText: 'x'
            min: Globals.BackendWrapper.activeBackend.analysis.axesRanges["xmin"]
            max: Globals.BackendWrapper.activeBackend.analysis.axesRanges["xmax"]
        }
        // axisX

        // axisY
        axisY: ValueAxis {
            //visible: true
            //gridVisible: false
            //subGridVisible: true
            //labelsVisible: true
            //subTickCount: 1

            labelDelegate: TextEdit {
                horizontalAlignment: TextInput.AlignRight
                verticalAlignment: Text.AlignVCenter
                rightPadding: -EaStyle.Sizes.fontPixelSize
                color: EaStyle.Colors.chartLabels
            }


            titleText: 'y'
            min: Globals.BackendWrapper.activeBackend.analysis.axesRanges["ymin"]
            max: Globals.BackendWrapper.activeBackend.analysis.axesRanges["ymax"]
        }
        // axisY

        // areaSeries
        AreaSeries {

            borderWidth: EaStyle.Sizes.measuredLineWidth
            borderColor: EaStyle.Colors.chartForegrounds[0]
            color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.15)

            upperSeries: LineSeries {
                id: upperSeries

                // Default points for Live Mode in Design
                XYPoint { x: 0; y: 2 }
                XYPoint { x: 40; y: 9.5 }
                XYPoint { x: 100; y: 3.8 }

                // Update series data when backend emits new points
                Connections {
                    target: Globals.BackendWrapper.activeBackend.analysis
                    function onDataPointsChanged(points) {
                        upperSeries.replace(points)
                    }
                }

            }

        }
        // areaSeries

        Component.onCompleted: {
            Globals.BackendWrapper.activeBackend.analysis.generateData()
        }
    }
    // graph

    // plotAreaBorder
    Rectangle {
        id: plotAreaBorder
        color: "transparent"
        border.color: EaStyle.Colors.chartGridLine
        border.width: 1

        x: graph.plotArea.x
        y: graph.plotArea.y
        width: graph.plotArea.width
        height: graph.plotArea.height
    }
    // plotAreaBorder

    // mouseArea
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true

        // Right-click → zoom out (reset view)
        onClicked: {
            graph.axisX.zoom = 1.0
            graph.axisY.zoom = 1.0
            graph.axisX.pan = 0.0
            graph.axisY.pan = 0.0
        }
    }
    // mouseArea
}
