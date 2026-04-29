import QtQuick
import QtQuick.Controls
import QtWebEngine

import EasyApp.Gui.Style as EaStyle


WebEngineView {
    id: chartView

    visible: false

    property bool loadSucceededStatus: false

    property string xAxisTitle: ''
    property string yAxisTitle: ''

    property var measuredXYData: ({})
    property var calculatedXYData: ({})

    property int theme: EaStyle.Colors.theme

    width: parent.width
    height: parent.height

    backgroundColor: EaStyle.Colors.chartBackground

    url: Qt.resolvedUrl("../Html/BasicReport.html")

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setChartSizes()
            setChartColors()

            setXAxisTitle()
            setYAxisTitle()

            setMeasuredXYData()
            setCalculatedXYData()

            redrawPlot()

            visible = true
        }
    }

    onLoadingChanged: {
        // Bug "loadRequest" is not declared - https://bugreports.qt.io/browse/QTBUG-84746
        //if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
        loadSucceededStatus = false
        if (loadProgress === 100) {
            loadSucceededStatus = true
        }
    }

    onXAxisTitleChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle()
            redrawPlot()
        }
    }

    onYAxisTitleChanged: {
        if (loadSucceededStatus) {
            setYAxisTitle()
            redrawPlot()
        }
    }

    onMeasuredXYDataChanged: {
        if (loadSucceededStatus) {
            setMeasuredXYData()
            redrawPlot()
        }
    }

    onCalculatedXYDataChanged: {
        if (loadSucceededStatus) {
            setCalculatedXYData()
            redrawPlot()
        }
    }

    onThemeChanged: {
        if (loadSucceededStatus) {
            setChartColors()
            redrawPlot()
        }
    }

    // Logic

    function setChartSizes() {
        const sizes = {
            'fontPixelSize': EaStyle.Sizes.fontPixelSize,
            'measuredLineWidth': EaStyle.Sizes.measuredLineWidth,
            'calculatedLineWidth': EaStyle.Sizes.calculatedLineWidth,
            'measuredScatterSize': EaStyle.Sizes.measuredScatterSize
        }
        runJavaScript(`setChartSizes(${JSON.stringify(sizes)})`, function(result) { print(result) })
    }

    function setChartColors() {
        const colors = {
            'chartBackground': String(EaStyle.Colors.chartBackground),
            'chartPlotAreaBackground': String(EaStyle.Colors.chartPlotAreaBackground),
            'chartForeground': String(EaStyle.Colors.chartForeground),

            'chartAxis': String(EaStyle.Colors.chartAxis),
            'chartGrid': String(EaStyle.Colors.chartGridLine),

            'measuredScatter': EaStyle.Colors.chartForegroundsExtra[2],
            'measuredLine': EaStyle.Colors.chartForegroundsExtra[2],
            'calculatedLine': EaStyle.Colors.chartForegrounds[0]
        }
        runJavaScript(`setChartColors(${JSON.stringify(colors)})`, function(result) { print(result) })
    }

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function setXAxisTitle() {
        runJavaScript(`setXAxisTitle(${JSON.stringify(xAxisTitle)})`)
    }

    function setYAxisTitle() {
        runJavaScript(`setYAxisTitle(${JSON.stringify(yAxisTitle)})`)
    }

    function setMeasuredXYData() {
        runJavaScript(`setMeasuredXYData(${JSON.stringify(measuredXYData)})`)
    }

    function setCalculatedXYData() {
        runJavaScript(`setCalculatedXYData(${JSON.stringify(calculatedXYData)})`)
    }

}
