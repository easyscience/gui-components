import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

Rectangle {
    id: indicatorItem

    property Item control
    property int checkState: control.checkState

    implicitWidth: EaStyle.Sizes.fontPixelSize * 1.5
    implicitHeight: EaStyle.Sizes.fontPixelSize * 1.5

    radius: 2

    color: EaStyle.Colors.themeBackgroundHovered2
    Behavior on color { EaAnimations.ThemeChange {} }

    border.color: !control.enabled ? EaStyle.Colors.themeForegroundDisabled :
                                     control.checked ?
                                         control.color :
                                         control.hovered ? EaStyle.Colors.themeForegroundHovered :
                                                           EaStyle.Colors.appBarComboBoxBorder
    Behavior on border.color { EaAnimations.ThemeChange {} }

    border.width: checkState !== Qt.Unchecked ? width / 2 : 1
    Behavior on border.width {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    EaElements.Label {
        id: checkSymbol

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        text: "\uf00c"

        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: EaStyle.Sizes.fontPixelSize

        scale: indicatorItem.checkState === Qt.Checked ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }

        color: indicatorItem.enabled ?
                   "white" ://EaStyle.Colors.checkSymbol :
                   EaStyle.Colors.themeForegroundDisabled
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 12
        height: 3

        scale: indicatorItem.checkState === Qt.PartiallyChecked ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
    }

    states: [
        State {
            name: "checked"
            when: indicatorItem.checkState === Qt.Checked
        },
        State {
            name: "partiallychecked"
            when: indicatorItem.checkState === Qt.PartiallyChecked
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                // Go down 2 pixels in size.
                to: 1 - 2 / indicatorItem.width
                duration: 120
            }
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                to: 1
                duration: 120
            }
        }
    }
}
