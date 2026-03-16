import QtQuick

import EasyApp.Gui.Elements as EaElements

EaElements.TextInput {
    property string headerText: ""

    height: parent.height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Keys.onReturnPressed: {
        accepted()
        focus = false
    }
    Keys.onEnterPressed: {
        accepted()
        focus = false
    }
}
