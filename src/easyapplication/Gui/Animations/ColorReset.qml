import QtQuick

import EasyApp.Gui.Style as EaStyle

SequentialAnimation {
    property alias target: colorChangeAnimo.target
    property alias to: colorChangeAnimo.to

    alwaysRunToEnd: false

    PauseAnimation {
        alwaysRunToEnd: false
        duration: 1000
    }

    PropertyAnimation {
        id: colorChangeAnimo

        alwaysRunToEnd: false
        target: parent.target
        property: 'color'
        duration: 1000
    }
}
