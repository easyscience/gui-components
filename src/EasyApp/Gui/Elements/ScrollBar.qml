import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

import EasyApp.Gui.Style as EaStyle

T.ScrollBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 1
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: orientation === Qt.Horizontal ? height / width : width / height

    contentItem: Rectangle {

        color: control.pressed ?
                   EaStyle.Colors.themeAccent :
                   control.interactive && control.hovered ?
                       EaStyle.Colors.themeForegroundMinor :
                       EaStyle.Colors.themeForegroundDisabled
        opacity: 0.0
    }

    background: Rectangle {
        implicitWidth: control.interactive && (control.hovered || control.pressed) ? 12 : 6
        implicitHeight: control.interactive && (control.hovered || control.pressed) ? 12 : 6
        color: "#0e000000"
        opacity: 0.0
        visible: control.interactive

        Behavior on implicitWidth {
            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        }
        Behavior on implicitHeight {
            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        }
    }

    states: State {
        name: "active"
        when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
    }

    transitions: [
        Transition {
            to: "active"
            NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 1.0 }
        },
        Transition {
            from: "active"
            SequentialAnimation {
                PropertyAction{ targets: [control.contentItem, control.background]; property: "opacity"; value: 1.0 }
                PauseAnimation { duration: 2450 }
                NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 0.0 }
            }
        }
    ]
}
