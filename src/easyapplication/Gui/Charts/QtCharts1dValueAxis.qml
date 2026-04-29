import QtQuick
import QtCharts

import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals 1.0 as EaGlobals


ValueAxis {
    property string title: ""
    property real minAfterReset: 0
    property real maxAfterReset: 1

    lineVisible: false // Hide axes lines (only grid is visible)

    color: EaStyle.Colors.chartAxis
    Behavior on color { EaAnimations.ThemeChange {} }

    gridLineColor: EaStyle.Colors.chartGridLine
    Behavior on gridLineColor { EaAnimations.ThemeChange {} }

    minorGridLineColor: EaStyle.Colors.chartMinorGridLine
    Behavior on minorGridLineColor { EaAnimations.ThemeChange {} }

    labelsColor: EaStyle.Colors.chartLabels
    Behavior on labelsColor { EaAnimations.ThemeChange {} }

    titleText: `<font color='${labelsColor}'>${title}</font>` // The only way to change a title color

    labelsFont.family: EaStyle.Fonts.fontFamily
    labelsFont.pixelSize: EaStyle.Sizes.fontPixelSize
    titleFont.family: EaStyle.Fonts.fontFamily
    titleFont.pixelSize: EaStyle.Sizes.fontPixelSize
}
