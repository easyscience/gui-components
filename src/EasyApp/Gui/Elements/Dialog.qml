import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material.impl
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.Dialog {
    id: control

    parent: Overlay.overlay
    //modal: true

    x: (parent.width - width) * 0.5
    y: (parent.height - height) * 0.5

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    spacing: EaStyle.Sizes.fontPixelSize

    topPadding: EaStyle.Sizes.fontPixelSize
    bottomPadding: EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize * 2
    rightPadding: EaStyle.Sizes.fontPixelSize * 2

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    enter: Transition {
        // grow_fade_in
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        // shrink_fade_out
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    background: Rectangle {
        radius: 2

        color: EaStyle.Colors.dialogBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        layer.enabled: EaStyle.Sizes.dialogElevation
        layer.effect: ElevationEffect {
            elevation: EaStyle.Sizes.dialogElevation
        }
    }

    header: EaElements.Label {
        text: control.title
        visible: control.title
        elide: Label.ElideRight
        padding: EaStyle.Sizes.fontPixelSize * 1.2
        topPadding: EaStyle.Sizes.fontPixelSize * 1.0
        bottomPadding: 0
        // TODO: QPlatformTheme::TitleBarFont
        font.bold: true
        font.pixelSize: control.font.pixelSize *1.0

        color: EaStyle.Colors.dialogForeground
        Behavior on color { EaAnimations.ThemeChange {} }

        background: PaddedRectangle {
            radius: 2
            bottomPadding: -2
            clip: true

            color: EaStyle.Colors.dialogBackground
            Behavior on color {
                PropertyAnimation {
                    duration: EaStyle.Times.themeChange
                    alwaysRunToEnd: true
                    easing.type: Easing.OutQuint
                }
            }
        }
    }

    footer: EaElements.DialogButtonBox {
        visible: count > 0
    }

    T.Overlay.modal: Rectangle {
        color: EaStyle.Colors.dialogOutsideBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    T.Overlay.modeless: Rectangle {
        color: EaStyle.Colors.dialogOutsideBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }
}
