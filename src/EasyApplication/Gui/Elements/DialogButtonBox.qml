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

    // A standard button takes the icon of its role; every button in a popup has one. A box with its own delegate
    // gives it roleIcon(DialogButtonBox.buttonRole).
    delegate: EaElements.Button {
        highlighted: true
        fontIcon: control.roleIcon(T.DialogButtonBox.buttonRole)
    }
    function roleIcon(role) {
        switch (role) {
        case T.DialogButtonBox.AcceptRole:
        case T.DialogButtonBox.YesRole:
        case T.DialogButtonBox.ApplyRole:
            return "check"
        case T.DialogButtonBox.RejectRole:
        case T.DialogButtonBox.NoRole:
            return "times"
        case T.DialogButtonBox.DestructiveRole:
            return "trash"
        case T.DialogButtonBox.ResetRole:
            return "undo"
        case T.DialogButtonBox.HelpRole:
            return "question-circle"
        default:
            return ""
        }
    }

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
