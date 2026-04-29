import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

EaElements.TabButton {
    id: control

    implicitHeight: EaStyle.Sizes.appBarHeight

    // Icon with text label
    contentItem: Item {
        implicitWidth: row.width

        Column {
            id: row
            spacing: 0 //control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize * 1.5

                text: control.fontIcon

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }

            // Text label
            Label {
                id: textLabel

                anchors.horizontalCenter: parent.horizontalCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize * 0.95
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
        implicitWidth: textLabel.implicitWidth + control.font.pixelSize * 1.5

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
                //console.error(`${control} [AppBarTabButton.qml] hovered`)
            }
        }
    }

    // Logic

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackground
        if (mouseHoverHandler.hovered)
            return EaStyle.Colors.themeBackgroundHovered2
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseHoverHandler.hovered || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }
}
