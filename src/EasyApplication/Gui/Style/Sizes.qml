pragma Singleton

import QtQuick
import QtQuick.Window

QtObject {

    // Application window
    property int appWindowWidthVGA: scalePx(640)
    property int appWindowWidthSVGA: scalePx(800)
    property int appWindowWidthXGA: scalePx(1024)
    property int appWindowWidthWXGA: scalePx(1280)

    property int appWindowHeightVGA: scalePx(480)
    property int appWindowHeightSVGA: scalePx(600)
    property int appWindowHeightXGA: scalePx(768)
    property int appWindowHeightWXGA: scalePx(800)

    property int appWindowMinimumWidth: appWindowWidthWXGA
    property int appWindowMinimumHeight: appWindowHeightXGA

    property int appWindowWidth: Qt.platform.pluginName === "wasm" ? Screen.width : Math.min(appWindowMinimumWidth, Screen.width)
    property int appWindowHeight: Qt.platform.pluginName === "wasm" ? Screen.height : Math.min(appWindowMinimumHeight, Screen.height)

    property int appWindowX: Qt.platform.pluginName === "wasm" ? 0 : (Screen.width - appWindowWidth) * 0.5
    property int appWindowY: Qt.platform.pluginName === "wasm" ? 0 : (Screen.height - appWindowHeight) * 0.5

    // Application bar
    property int appBarHeight: Math.round(fontPixelSize * 5.5)
    property int appBarSpacing: fontPixelSize

    // Sidebar
    readonly property int sideBarWidth: Math.round(fontPixelSize * 41.7)
    property int groupBoxSpacing: fontPixelSize
    property int sideBarPadding: fontPixelSize
    property int sideBarContentWidth: sideBarWidth - groupBoxSpacing - sideBarPadding
    property int sideBarButtonHeight: Math.round(fontPixelSize * 2.75)

    // Sidebar Table
    property int tableColumnSpacing: Math.round(fontPixelSize * 0.25)  // Math.round(fontPixelSize * 0.5)
    property int tableRowHeight: Math.round(fontPixelSize * 2.75)
    property int tableMaxRowCountShow: 5
    property int tableHighlightMoveDuration: 100

    // Status bar
    property int statusBarHeight: Math.round(fontPixelSize * 2.5)
    property int statusBarSpacing: fontPixelSize

    // Tabbar
    property int tabBarHeight: Math.round(fontPixelSize * 3)

    // Dialogs
    property int dialogElevation: Math.round(fontPixelSize * 2)

    // ComboBox
    property int comboBoxHeight: Math.round(fontPixelSize * 2.5)

    // Buttons
    property int buttonHeight: Math.round(fontPixelSize * 2.0)
    property int toolButtonHeight: Math.round(fontPixelSize * 2.5)

    // Touch
    property int touchSize: Math.round(fontPixelSize * 2.0)

    // Fonts
    //property int fontPixelSize: scalePx(14) //scalePx(Qt.application.font.pixelSize)
    property Text _text: Text { font.pixelSize: scalePx(14) }
    property int fontPointSize: _text.font.pointSize
    property int fontPixelSize: _text.font.pixelSize

    // Border
    readonly property int borderThickness: 1

    // Tooltips
    property int tooltipHeight: Math.round(fontPixelSize * 2)

    // Scales
    property int defaultScale: 100

    // Charts
    property int measuredLineWidth: 1
    property int calculatedLineWidth: 2
    property int measuredScatterSize: 5

    // Functions
    function scalePx(size) {
        return Math.round(size * (defaultScale / 100))
    }
}
