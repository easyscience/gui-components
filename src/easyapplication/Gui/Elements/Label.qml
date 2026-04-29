import QtQuick
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

T.Label {
    id: control

    property bool selected: false
    property color backgroundColor: "transparent"

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    //textFormat: Text.StyledText

    color: selected ?
               EaStyle.Colors.themeForegroundHovered :
               enabled ?
                   EaStyle.Colors.themeForeground :
                   EaStyle.Colors.themeForegroundDisabled
    Behavior on color { EaAnimations.ThemeChange {} }

    linkColor: hoveredLink ?
                   EaStyle.Colors.linkHovered :
                   EaStyle.Colors.link
    Behavior on linkColor { EaAnimations.ThemeChange {} }

    background: Rectangle {
        width: control.width
        height: control.height

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: false
        //cursorShape: undefined  // prevents changing the cursor
        cursorShape: parent.hoveredLink ?
                         Qt.PointingHandCursor :
                         undefined //Qt.ArrowCursor
    }

    onLinkActivated: Qt.openUrlExternally(link)
}
