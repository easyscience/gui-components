import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Charts as EaCharts


ChartView {
    id: chartView

    property alias axisX: axisX
    property alias axisY: axisY

    property bool useOpenGL: false
    property bool allowZoom: true
    property bool allowHover: true

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: -12 // Reset default margins

    antialiasing: true

    legend.visible: false
    legend.alignment: Qt.AlignBottom
    legend.font.family: EaStyle.Fonts.fontFamily
    legend.font.pixelSize: EaStyle.Sizes.fontPixelSize
    legend.markerShape: Legend.MarkerShapeRectangle
    legend.labelColor: EaStyle.Colors.chartForeground
    Behavior on legend.labelColor { EaAnimations.ThemeChange {} }

    backgroundRoundness: 0
    backgroundColor: EaStyle.Colors.chartBackground
    Behavior on backgroundColor { EaAnimations.ThemeChange {} }

    titleFont.family: EaStyle.Fonts.fontFamily
    titleFont.pixelSize: EaStyle.Sizes.fontPixelSize
    titleFont.bold: true
    titleColor: EaStyle.Colors.chartForeground
    /* BREAKS ANIMATION !
    Behavior on titleColor { Animations.ThemeChange {} }
    */

    plotAreaColor: EaStyle.Colors.chartPlotAreaBackground
    Behavior on plotAreaColor { EaAnimations.ThemeChange {} }

    animationOptions: ChartView.SeriesAnimations
    animationDuration: EaStyle.Times.chartAnimation

    // X-axis
    EaCharts.QtCharts1dValueAxis {
        id: axisX
    }

    // Y-axis
    EaCharts.QtCharts1dValueAxis {
        id: axisY
    }

    // Zoom rectangle
    Rectangle{
        id: recZoom

        property int xScaleZoom: 0
        property int yScaleZoom: 0

        visible: false
        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: recZoom.xScaleZoom
            yScale: recZoom.yScaleZoom
        }
        border.color: EaStyle.Colors.appBorder
        border.width: 1
        opacity: 0.9
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: recZoom.border.color
        }
    }

    // Zoom with left mouse button
    MouseArea {
        id: zoomMouseArea

        enabled: allowZoom
        anchors.fill: chartView
        acceptedButtons: Qt.LeftButton
        onPressed: {
            recZoom.x = mouseX
            recZoom.y = mouseY
            recZoom.visible = true
        }
        onMouseXChanged: {
            if (mouseX > recZoom.x) {
                recZoom.xScaleZoom = 1
                recZoom.width = Math.min(mouseX, chartView.width) - recZoom.x
            } else {
                recZoom.xScaleZoom = -1
                recZoom.width = recZoom.x - Math.max(mouseX, 0)
            }
        }
        onMouseYChanged: {
            if (mouseY > recZoom.y) {
                recZoom.yScaleZoom = 1
                recZoom.height = Math.min(mouseY, chartView.height) - recZoom.y
            } else {
                recZoom.yScaleZoom = -1
                recZoom.height = recZoom.y - Math.max(mouseY, 0)
            }
        }
        onReleased: {
            const x = Math.min(recZoom.x, mouseX) - chartView.anchors.leftMargin
            const y = Math.min(recZoom.y, mouseY) - chartView.anchors.topMargin
            const width = recZoom.width
            const height = recZoom.height
            chartView.zoomIn(Qt.rect(x, y, width, height))
            recZoom.visible = false
        }
    }

    // Pan with left mouse button
    MouseArea {
        property real pressedX
        property real pressedY
        property int threshold: 1

        enabled: !zoomMouseArea.enabled
        anchors.fill: chartView
        acceptedButtons: Qt.LeftButton
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onMouseXChanged: Qt.callLater(update)
        onMouseYChanged: Qt.callLater(update)

        function update() {
            const dx = mouseX - pressedX
            const dy = mouseY - pressedY
            pressedX = mouseX
            pressedY = mouseY

            if (dx > threshold)
                chartView.scrollLeft(dx)
            else if (dx < -threshold)
                chartView.scrollRight(-dx)
            if (dy > threshold)
                chartView.scrollUp(dy)
            else if (dy < -threshold)
                chartView.scrollDown(-dy)
        }
    }

    // Reset axes with right mouse button
    MouseArea {
        anchors.fill: chartView
        acceptedButtons: Qt.RightButton
        onClicked: resetAxes()
    }

    // Logic

    function resetAxes() {
        //chartView.zoomReset()
        axisX.min = axisX.minAfterReset
        axisX.max = axisX.maxAfterReset
        axisY.min = axisY.minAfterReset
        axisY.max = axisY.maxAfterReset
    }

}
