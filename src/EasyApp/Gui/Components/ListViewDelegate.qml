import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: control

    default property alias contentRowData: contentRow.data
    //property alias mouseArea: mouseArea
    property Item tableView: parent === null ? null : parent.parent

    implicitWidth: ListView.view.parent.width
    implicitHeight: tableView === null ? EaStyle.Sizes.tableRowHeight : tableView.tableRowHeight

    color: {
        ListView.view.parent.selectionRevision

        let selected = ListView.view.parent.isSelected(index)
        let c1 = EaStyle.Colors.themeAccentMinor
        let c2 = EaStyle.Colors.themeBackgroundHovered2
        let c3 = EaStyle.Colors.themeBackgroundHovered1

        return selected ? c1 : (index % 2 ? c2 : c3)
    }
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
        onReleased: (mouse) => {
            control.ListView.view.parent.selectWithModifiers(index, mouse.modifiers)
        }
    }

    // TapHandler {
    //     acceptedButtons: Qt.LeftButton // | Qt.RightButton  // match whatever you need
    //     onTapped: (eventPoint, button) => {
    //         control.ListView.view.parent.selectWithModifiers(index, eventPoint.modifiers)
    //     }
    // }

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
