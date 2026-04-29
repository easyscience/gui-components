// SPDX-FileCopyrightText: 2022 EasyTexture contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2022 Contributors to the EasyTexture project <https://github.com/EasyScience/EasyTextureApp>

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10

import easyApp.Gui.Elements 1.0 as EaElements

Rectangle {
    id: container

    property var xArrayValues: [0, 1, 2]
    property var yArrayValues: [1.0, 0.0, 0.5]
    property int xyArraysLength: xArrayValues.length

    property string xAxisTitle: 'X axis'
    property string yAxisTitle: 'Y axis'

    property int pageLoading: chartView.loading

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.bottomMargin: 20
        anchors.topMargin: 18
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        backgroundColor: parent.color

        url: 'ChartTemplateSimple1dPlotly.html'

        onContextMenuRequested: {
            request.accepted = true
        }

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                setXAxisTitle()
                setYAxisTitle()
                setXArrayValues()
                setYArrayValues()
                redrawPlot()
            }
        }

        onWidthChanged: reload()
        onHeightChanged: reload()        

    }

    // Logic

    function setXAxisTitle() {
        //chartView.runJavaScript(`setXAxisTitle(${xAxisTitle})`, function(result) { console.log(result); })
        chartView.runJavaScript(`setXAxisTitle(${JSON.stringify(xAxisTitle)})`)
    }

    function setYAxisTitle() {
        chartView.runJavaScript(`setYAxisTitle(${JSON.stringify(yAxisTitle)})`)
    }

    function setXArrayValues(newValues) {
        //chartView.runJavaScript(`setXArrayValues(${JSON.stringify(xArrayValues)})`, function(result) { console.log(result); })
        chartView.runJavaScript(`setXArrayValues(${JSON.stringify(xArrayValues)})`)
    }

    function setYArrayValues(newValues) {
        //chartView.runJavaScript(`setYArrayValues(${JSON.stringify(yArrayValues)})`, function(result) { console.log(result); })
        chartView.runJavaScript(`setYArrayValues(${JSON.stringify(yArrayValues)})`)
    }

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function redrawPlotWithYAnimation() {
        chartView.runJavaScript(`redrawPlotWithYAnimation()`)
    }

}
