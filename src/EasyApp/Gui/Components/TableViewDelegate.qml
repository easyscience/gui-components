import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: control

    default property alias contentRowData: contentRow.data
    property alias mouseArea: mouseArea
    property Item tableView: parent === null ? null : parent.parent

    implicitWidth: parent == null ? 0 : parent.width
    implicitHeight: tableView === null ? EaStyle.Sizes.tableRowHeight : tableView.tableRowHeight

    color: index % 2 ?
               EaStyle.Colors.themeBackgroundHovered2 :
               EaStyle.Colors.themeBackgroundHovered1
    Behavior on color { EaAnimations.ThemeChange {} }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true
        cursorShape: undefined //Qt.PointingHandCursor
        hoverEnabled: false
        onPressed: (mouse) => mouse.accepted = false
    }

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        cursorShape: Qt.PointingHandCursor
        blocking: false
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TableViewDelegate.qml] hovered`)
                parent.ListView.view.currentIndex = index
            }
        }
    }

}
