import QtQuick

import EasyApp.Gui.Style as EaStyle

Image {
    id: control
    property string link: ""

    fillMode: Image.PreserveAspectFit
    antialiasing: true

    MouseArea {
         id: imageLink
         enabled: true
         anchors.fill: parent
         cursorShape: Qt.PointingHandCursor
         onClicked: Qt.openUrlExternally(link)
    }

}
