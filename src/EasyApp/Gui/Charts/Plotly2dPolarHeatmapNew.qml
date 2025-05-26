import QtQuick
import QtQuick.Controls
import QtWebEngine

import Gui.Globals as Globals

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string colorbarTitle: ''

    property var plotData: ({})

    width: parent.width
    height: parent.height

    url:  Qt.resolvedUrl('../Html/Plotly2dPolarHeatmapNew.html')

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

    onColorbarTitleChanged: {
        if (loadSucceededStatus) {
            setColorbarTitle()
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

    function setColorbarTitle() {
        runJavaScript(`setColorbarTitle(${JSON.stringify(colorbarTitle)})`)
    }

    function setXyzData() {
        runJavaScript(`setXyzData(${JSON.stringify(plotData)})`)
    }

}
