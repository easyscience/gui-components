import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: listViewHeader
    default property alias contentRowData: contentRow.data
    property Item listView: ListView.view ? ListView.view.parent : null

    visible: listView && listView.showHeader

    z: 3 // To display header above delegate and highlighted area

    implicitWidth: parent === null ? 0 : parent.width
    implicitHeight: listView && listView.showHeader ? listView.tableRowHeight : 0

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    Component.onCompleted: Qt.callLater(function() { if (listView) listView.applyWidths(contentRow) })

    Connections {
        target: listView
        function onResolvedColumnWidthsChanged() { listView.applyWidths(contentRow) }
    }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }
}
