import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string xAxisTitle: ''
    property string yAxisTitle: ''
    property string colorbarTitle: ''

    property var plotData: ({})

    width: parent.width
    height: parent.height

    url: Qt.resolvedUrl('../Html/Plotly2dHeatmapNew.html')

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            redrawPlot()
        }
    }

    onLoadingChanged: {
        // Bug "loadRequest" is not declared - https://bugreports.qt.io/browse/QTBUG-84746
        //if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
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

    onPlotDataChanged: {
        if (loadSucceededStatus) {
            setXyzData()
            redrawPlot()
        }
    }

    // Logic

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function setXAxisTitle() {
        runJavaScript(`setXAxisTitle(${JSON.stringify(xAxisTitle)})`)
    }

    function setYAxisTitle() {
        runJavaScript(`setYAxisTitle(${JSON.stringify(yAxisTitle)})`)
    }

    function setColorbarTitle() {
        runJavaScript(`setColorbarTitle(${JSON.stringify(colorbarTitle)})`)
    }

    function setXyzData() {
        runJavaScript(`setXyzData(${JSON.stringify(plotData)})`)
    }

}
