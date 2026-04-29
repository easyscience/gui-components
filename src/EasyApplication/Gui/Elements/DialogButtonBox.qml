import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements

T.DialogButtonBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: EaStyle.Sizes.fontPixelSize * 2

    topPadding: 0
    bottomPadding: EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize * 1.5
    rightPadding: EaStyle.Sizes.fontPixelSize * 1.5
    verticalPadding: 2

    alignment: Qt.AlignRight
    buttonLayout: T.DialogButtonBox.AndroidLayout

    delegate: EaElements.Button { highlighted: true }

    contentItem: ListView {
        implicitWidth: contentWidth
        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    // Buttons area
    background: PaddedRectangle {
        color: EaStyle.Colors.dialogBackground
        Behavior on color { EaAnimations.ThemeChange {} }
    }
}
