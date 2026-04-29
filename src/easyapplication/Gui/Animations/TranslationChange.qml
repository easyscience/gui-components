import QtQuick

import EasyApp.Gui.Style as EaStyle

SequentialAnimation {

    // Animation with old text
    ParallelAnimation {
        NumberAnimation {
            target: parent
            property: "opacity"
            to: 0
            duration: EaStyle.Times.translationChange
            easing.type: Easing.InCirc
        }
    }

    // Text changed
    PropertyAction {}

    // Animation with new text
    ParallelAnimation {
        NumberAnimation {
            target: parent
            property: "opacity"
            to: 1
            duration: EaStyle.Times.translationChange
            easing.type: Easing.OutCirc
        }
    }

}
