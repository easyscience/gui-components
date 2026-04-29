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

    property string keyIcon: ''
    property string keyText: ''
    property string valueText: ''

    visible: valueText !== ''

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    padding: 0
    spacing: EaStyle.Sizes.fontPixelSize * 0.5
    anchors.verticalCenter: parent.verticalCenter

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // contentItem
    contentItem: Item {
        implicitWidth: row.width
        implicitHeight: row.height

        // contentItem row layout
        Row {
            id: row
            spacing: control.spacing
            anchors.verticalCenter: parent.verticalCenter

            // key icon
            Label {
                text: control.keyIcon

                height: font.pixelSize
                verticalAlignment: Text.AlignVCenter

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize

                color: EaStyle.Colors.statusBarIconForeground
                Behavior on color { EaAnimations.ThemeChange {} }
            }
            // key icon

            // key text
            Label {
                text: control.keyText

                visible: control.parent.width > EaStyle.Sizes.appWindowWidthWXGA

                height: font.pixelSize
                verticalAlignment: Text.AlignVCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                color: EaStyle.Colors.statusBarTextForeground
                Behavior on color { EaAnimations.ThemeChange {} }
            }
            // key text

            // value text
            Label {
                id: valueLabel

                text: control.valueText
                onTextChanged: {
                    color = EaStyle.Colors.themeForegroundHovered
                    colorResetAnimo.restart()
                }

                height: font.pixelSize
                verticalAlignment: Text.AlignVCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                color: EaStyle.Colors.themeForeground
                Behavior on color { EaAnimations.ThemeChange {} }

                EaAnimations.ColorReset {
                    id: colorResetAnimo

                    target: valueLabel
                    to: EaStyle.Colors.themeForeground
                }
            }
            // value text

        }
        // contentItem row layout
    }
    // contentItem

    // background
    background: Rectangle {
        color: 'transparent'
    }
    // background

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: text !== "" &&
                 control.hovered &&
                 EaGlobals.Vars.showToolTips
    }
    // ToolTip

}
