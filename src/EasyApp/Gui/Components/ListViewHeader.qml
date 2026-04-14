import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: listViewHeader
    default property alias contentRowData: contentRow.data
    property Item listView: ListView.view ?? null

    z: 3 // To display header above delegate and highlighted area

    implicitWidth: parent === null ? 0 : parent.width
    implicitHeight: listView ? listView.tableRowHeight : 0

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    Component.onCompleted: if (listView) listView.applyWidths(contentRow)

    Connections {
        target: listView
        function onResolvedColumnWidthsChanged() { listView.applyWidths(contentRow) }
    }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }

    // Header sits above delegate 0 (OverlayHeader). Without an input
    // handler here, clicks fall through to that delegate's MouseArea,
    // bypassing the ListView-level TapHandler. This claims the press
    // so header clicks transfer focus to the list.
    MouseArea {
        anchors.fill: parent
        onClicked: if (listView) listView.forceActiveFocus()
    }
}
