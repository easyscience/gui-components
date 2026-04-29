import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string xAxisTitle: ''
    property string yAxisTitle: ''
    property string zAxisTitle: ''

    width: parent.width
    height: parent.height

    url:  Qt.resolvedUrl('../Html/Plotly3dScatter.html')

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle(xAxisTitle)
            setYAxisTitle(yAxisTitle)
            setZAxisTitle(zAxisTitle)
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
            setXAxisTitle(newTitle)
            redrawPlot()
        }
    }

    onYAxisTitleChanged: {
        if (loadSucceededStatus) {
            setYAxisTitle(newTitle)
            redrawPlot()
        }
    }

    onZAxisTitleChanged: {
        if (loadSucceededStatus) {
            setZAxisTitle(newTitle)
            redrawPlot()
        }
    }

    // Logic

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function setXAxisTitle(newTitle) {
        runJavaScript(`setXAxisTitle(${JSON.stringify(newTitle)})`)
    }

    function setYAxisTitle(newTitle) {
        runJavaScript(`setYAxisTitle(${JSON.stringify(newTitle)})`)
    }

    function setZAxisTitle(newTitle) {
        runJavaScript(`setZAxisTitle(${JSON.stringify(newTitle)})`)
    }

}
