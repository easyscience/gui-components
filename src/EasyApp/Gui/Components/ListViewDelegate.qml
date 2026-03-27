import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: control

    default property alias contentRowData: contentRow.data
    property Item listView: ListView.view.parent

    implicitWidth: listView.width
    implicitHeight: listView.tableRowHeight

    color: {
        listView.selectionRevision

        let selected = listView.isSelected(index)
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
            listView.selectWithModifiers(index, mouse.modifiers)
        }
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
                listView.currentIndex = index
            }
        }
    }
}
