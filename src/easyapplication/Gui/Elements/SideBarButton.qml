import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.Button {
    id: control

    property bool wide: false
    property bool showBackground: true
    property bool smallIcon: false
    property int radius: 2
    property string fontIcon: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    padding: 0
    spacing: EaStyle.Sizes.fontPixelSize * 0.5

    flat: true

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: control.hovered && EaGlobals.Vars.showToolTips && text !== ""
    }
    // ToolTip

    // Icon with text label
    contentItem: Item {
        Row {
            spacing: control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                id: iconLabel
                anchors.verticalCenter: parent.verticalCenter


                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: smallIcon ?
                                    control.font.pixelSize * 1.0 :
                                    control.font.pixelSize * 1.25

                text: control.fontIcon

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
            // Icon

            // Text label
            Label {
                anchors.verticalCenter: parent.verticalCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                text: control.text

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
            // Text label
        }
    }
    // Icon with text label

    // Background
    background: Rectangle {
        visible: showBackground

        implicitWidth: wide ?
                           EaStyle.Sizes.sideBarContentWidth :
                           (EaStyle.Sizes.sideBarContentWidth - EaStyle.Sizes.fontPixelSize) / 2
        implicitHeight: EaStyle.Sizes.sideBarButtonHeight

        radius: control.radius

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor()//control.hovered ? EaStyle.Colors.themeBackground : EaStyle.Colors.appBarBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }
    // Background

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
                //console.error(`${control} [TabButton.qml] hovered`)
            }
        }
    }
    // Logic

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (mouseHoverHandler.hovered)
            return EaStyle.Colors.themeBackgroundHovered1
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseHoverHandler.hovered || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

    function borderColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (mouseHoverHandler.hovered || control.checked || control.down)
            return EaStyle.Colors.appBarBackground
        return EaStyle.Colors.appBarComboBoxBorder
    }

}

