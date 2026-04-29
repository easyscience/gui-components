import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.TabButton {
    id: control

    property bool highlighted: false
    property string fontIcon: ""
    property string iconColor: ""
    property string backgroundColor: getBackgroundColor()
    property color borderColor: "transparent"

    width: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                    implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topInset: 0
    bottomInset: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
    rightPadding: EaStyle.Sizes.fontPixelSize * 0.5
    spacing: EaStyle.Sizes.fontPixelSize * 0.5

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: text !== "" &&
                 control.hovered &&
                 EaGlobals.Vars.showToolTips
    }

    // Icon with text label
    contentItem: Item {
        implicitWidth: row.width

        Row {
            id: row
            width: childrenRect.width
            spacing: control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize

                text: control.fontIcon

                color: iconColor ? iconColor : foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
           }

            // Text label
            Label {
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize
                font.bold: control.checked ? true : false

                text: control.text

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }
    }

    // Background
    background: Rectangle {
        implicitHeight: EaStyle.Sizes.tabBarHeight

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: undefined //Qt.PointingHandCursor
        hoverEnabled: false
        onPressed: (mouse) => mouse.accepted = false
    }

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TabButton.qml] hovered`)
            }
        }
    }

    // Logic

    function getBackgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.contentBackground
        if (mouseHoverHandler.hovered)
            return EaStyle.Colors.themeBackgroundHovered1
        return EaStyle.Colors.contentBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (!highlighted) {
            if (mouseHoverHandler.hovered || control.checked || control.down)
                return EaStyle.Colors.themeForegroundHovered
            return EaStyle.Colors.themeForeground
        }
        return EaStyle.Colors.themeForegroundHighlight
    }
}
