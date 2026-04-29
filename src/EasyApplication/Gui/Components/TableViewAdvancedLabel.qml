import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements

T.Button {
    id: control

    property int horizontalAlignment: Text.AlignHCenter
    property int elide: Text.ElideMiddle
    property color color: enabled ?
               EaStyle.Colors.themeForeground :
               EaStyle.Colors.themeForegroundDisabled
    property color backgroundColor: "transparent"

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

    anchors.verticalCenter: parent.verticalCenter

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: label.truncated && control.hovered && EaGlobals.Vars.showToolTips && text !== ""
    }

    // Text label
    contentItem: Label {
        id: label

        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: control.horizontalAlignment

        font.family: control.font.family
        font.pixelSize: control.font.pixelSize

        text: control.text

        elide: control.elide

        color: control.color
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    background: Rectangle {
        width: control.width
        height: control.height

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }
}
