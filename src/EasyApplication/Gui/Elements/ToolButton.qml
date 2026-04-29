import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.ToolButton {
    id: control

    property string fontIcon: ""
    property bool showBackground: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    /*
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    */

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: control.hovered && EaGlobals.Vars.showToolTips && text !== ""
    }

    // Icon label
    contentItem: IconLabel {
        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: control.font.pixelSize * 1.25

        text: control.fontIcon

        color: foregroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // Background
    background: Rectangle {
        visible: showBackground

        implicitWidth: EaStyle.Sizes.toolButtonHeight
        implicitHeight: EaStyle.Sizes.toolButtonHeight

        radius: EaStyle.Sizes.toolButtonHeight * 0.5

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: false
        cursorShape: undefined //Qt.PointingHandCursor
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
                //console.error(`${control} [ToolButton.qml] hovered`)
            }
        }
    }

    // Logic

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (mouseHoverHandler.hovered)
            return EaStyle.Colors.themeBackgroundHovered2
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (!highlighted) {
            if (control.checked || mouseHoverHandler.hovered)
                return EaStyle.Colors.themeForegroundHovered
            return EaStyle.Colors.themeForeground
        }
        return EaStyle.Colors.themeForegroundHighlight
    }
}
