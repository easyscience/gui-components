import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Charts as EaCharts


Rectangle {
    id: container

    default property alias chartViewData: chartView.data
    property bool allowZoom: true
    property bool useOpenGL: false
    property alias plotArea: chartView.plotArea
    property alias axisX: axisX
    property alias axisY: axisY

    //property alias bkgSerie: bkgSerie


    color: 'red'

ChartView {
    id: chartView

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: -12 // Reset default margins
    anchors.topMargin: EaStyle.Sizes.toolButtonHeight

    antialiasing: true

    legend.visible: false
    legend.alignment: Qt.AlignBottom
    legend.font.family: EaStyle.Fonts.fontFamily
    legend.font.pixelSize: EaStyle.Sizes.fontPixelSize
    legend.markerShape: Legend.MarkerShapeRectangle
    legend.labelColor: EaStyle.Colors.chartForeground
    Behavior on legend.labelColor { EaAnimations.ThemeChange {} }

    backgroundRoundness: 0
    backgroundColor: "blue"//EaStyle.Colors.chartBackground
    Behavior on backgroundColor { EaAnimations.ThemeChange {} }

    titleFont.family: EaStyle.Fonts.fontFamily
    titleFont.pixelSize: EaStyle.Sizes.fontPixelSize
    titleFont.bold: true
    titleColor: EaStyle.Colors.chartForeground
    /* BREAKS ANIMATION !
    Behavior on titleColor { Animations.ThemeChange {} }
    */

    plotAreaColor: "green"//EaStyle.Colors.chartPlotAreaBackground
    Behavior on plotAreaColor { EaAnimations.ThemeChange {} }

    animationOptions: ChartView.SeriesAnimations
    animationDuration: EaStyle.Times.chartAnimation

    EaCharts.QtCharts1dValueAxis {
        id: axisX
        //min:0
        //max:3

    }

    EaCharts.QtCharts1dValueAxis {
        id: axisY
        //min:0
        //max:2
    }

/*
    LineSeries {
      //   XYPoint { x: 0; y: 0.5 }
        // XYPoint { x: 0.5; y: 2.5 }

         axisX: container.axisX
         axisY: container.axisY

    }

    LineSeries {
        id: bkgSerie

        axisX: container.axisX
        axisY: container.axisY

        useOpenGL: chartView.useOpenGL

        color: EaStyle.Colors.chartForegrounds[1]
        width: 2

        Component.onCompleted: console.error(`bbbbbbbb ${container.axisX}`)

    }
    */

    // Zoom rectangle
    Rectangle{
        id: recZoom
        property int xScaleZoom: 0
        property int yScaleZoom: 0
        visible: false
        transform: Scale { origin.x: 0; origin.y: 0; xScale: recZoom.xScaleZoom; yScale: recZoom.yScaleZoom}
        border.color: "#999"
        border.width: 1
        opacity: 0.9
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: recZoom.border.color
        }
    }

    // Left mouse button events
    MouseArea {
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



    // Tool buttons
    Row {
        id: toolButtons

        x: chartView.plotArea.x + chartView.plotArea.width - width - EaStyle.Sizes.fontPixelSize
        y: chartView.plotArea.y - height - EaStyle.Sizes.fontPixelSize

        spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        EaElements.TabButton {
            checked: allowZoom
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "expand"
            ToolTip.text: qsTr("Box zoom")
            onClicked: allowZoom = !allowZoom
        }

        EaElements.TabButton {
            checkable: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "sync-alt"
            ToolTip.text: qsTr("Reset")
            onClicked: chartView.zoomReset()
        }

        EaElements.TabButton {
/////            checked: chartView.allowHover
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "comment-alt"
            ToolTip.text: qsTr("Hover")
////            onClicked: allowHover = !allowHover
        }
    }
    // Tool buttons




    // Right mouse button events
    MouseArea {
        anchors.fill: chartView
        acceptedButtons: Qt.RightButton
        onClicked: chartView.zoomReset()
    }
}

Component.onCompleted: console.error('BBBBBBBBBBBB')


}
