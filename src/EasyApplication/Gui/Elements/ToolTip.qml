import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Material.impl
import QtQuick.Templates as T

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements


T.ToolTip {
    id: control

    property color textColor: EaStyle.Colors.themeForeground
    property color backgroundColor: EaStyle.Colors.toolTipBackground
    property color borderColor: EaStyle.Colors.toolTipBorder
    property real backgroundOpacity: 0.9
    property real arrowLength: EaStyle.Sizes.fontPixelSize * 0.707
    property int borderRadius: 0.25 * EaStyle.Sizes.fontPixelSize
    property int textFormat: Text.PlainText //Text.RichText

    property int enterAnimationDuration: 1000
    property int exitAnimationDuration: 500

    property int guidesCount: 0
    property int currentGuideIndex: 0
    property alias controlButtons: controlButtons.data

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - EaStyle.Sizes.fontPixelSize * 0.5

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize
    rightPadding: EaStyle.Sizes.fontPixelSize
    topPadding: EaStyle.Sizes.fontPixelSize + control.arrowLength
    bottomPadding: EaStyle.Sizes.fontPixelSize + control.arrowLength
    //horizontalPadding: EaStyle.Sizes.fontPixelSize * 1.15

    closePolicy: T.Popup.CloseOnEscape |
                 T.Popup.CloseOnPressOutsideParent |
                 T.Popup.CloseOnReleaseOutsideParent

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    contentItem: Column {
        spacing: EaStyle.Sizes.fontPixelSize * 2

        // Top dots to highlight current index
        Row {
            visible: guidesCount
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            Repeater {
                model: guidesCount

                Rectangle {
                    width: EaStyle.Sizes.fontPixelSize * 0.5
                    height: EaStyle.Sizes.fontPixelSize * 0.5
                    radius: EaStyle.Sizes.fontPixelSize * 0.25
                    opacity: 0.5

                    color: index === currentGuideIndex ?
                               EaStyle.Colors.themeForeground :
                               EaStyle.Colors.themeForegroundDisabled
                    Behavior on color { EaAnimations.ThemeChange {} }
                }
            }
        }

        // Main text
        EaElements.Label {
            text: control.text
            textFormat: control.textFormat
            horizontalAlignment: Text.AlignHCenter

            font: control.font

            color: control.textColor
        }

        // Bottom buttons
        Row {
            id: controlButtons

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize
        }
    }

    background: Item{
        opacity: control.backgroundOpacity

        layer.enabled: true
        layer.effect: EaElements.ToolTipShadow {
            shadowColor: control.borderColor
        }


        Rectangle {
            x: -control.x - width / 2 + control.parent.width / 2
            y: control.y >= 0 ?
                   control.arrowLength * 0.207 + 1 :
                   parent.height - control.arrowLength * 1.707 - 1

            width: control.arrowLength / 0.707
            height: control.arrowLength / 0.707
            rotation: 45

            color: control.backgroundColor
        }
        Rectangle {
            y: control.arrowLength
            width: parent.width
            height: parent.height - 2 * control.arrowLength

            radius: control.borderRadius
            color: control.backgroundColor
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: enterAnimationDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InQuad
            duration: exitAnimationDuration
        }
    }
}

