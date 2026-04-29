import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Charts as EaCharts


EaCharts.QtCharts1dBase {
    id: chartView

    property alias measSerie: measSerie
    property alias bkgSerie: bkgSerie
    property alias calcSerie: calcSerie

    /*
    ScatterSeries {
        id: measSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        markerSize: 5
        borderWidth: 1
        color: EaStyle.Colors.chartForegroundsExtra[2]
        borderColor: this.color
    }
    */

    LineSeries {
        id: measSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: EaStyle.Colors.chartForegroundsExtra[2]
        width: 2
    }

    LineSeries {
        id: bkgSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: EaStyle.Colors.chartForegrounds[1]
        width: 2
    }

    LineSeries {
        id: calcSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: EaStyle.Colors.chartForegrounds[0]
        width: 2
    }

}
