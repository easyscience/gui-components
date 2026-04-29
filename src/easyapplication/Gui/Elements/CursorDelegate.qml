import QtQuick

import EasyApp.Gui.Style as EaStyle

Rectangle {
    id: cursor

    visible: parent.activeFocus && !parent.readOnly && parent.selectionStart === parent.selectionEnd

    width: 2

    color: EaStyle.Colors.themeAccent

    /*
    Connections {
        target: cursor.parent
        onCursorPositionChanged: {
            // keep a moving cursor visible
            cursor.opacity = 1
            timer.restart()
        }
    }
    */

    Timer {
        id: timer
        running: cursor.parent.activeFocus && !cursor.parent.readOnly && interval != 0
        repeat: true
        interval: Qt.styleHints.cursorFlashTime / 2
        onTriggered: cursor.opacity = !cursor.opacity ? 1 : 0
        // force the cursor visible when gaining focus
        onRunningChanged: cursor.opacity = 1
    }
}
