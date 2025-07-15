import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string colorbarTitle: ''

    property var scene: ({})

    property var plotData: ({})

    width: parent.width
    height: parent.height

    url: Qt.resolvedUrl('../Html/Plotly3dSurface.html')

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

    onSceneChanged: {
        if (loadSucceededStatus) {
            setScene()
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

    function setScene() {
        runJavaScript(`setScene(${JSON.stringify(scene)})`)
    }

    function setXyzData() {
        runJavaScript(`setXyzData(${JSON.stringify(plotData)})`)
    }

}
