import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    default property alias contentRowData: contentRow.data
    property Item listView: parent.parent

    visible: listView.showHeader

    z: 3 // To display header above delegate and highlighted area

    implicitWidth: parent === null ? 0 : parent.width
    implicitHeight: listView.showHeader ? listView.tableRowHeight : 0

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    function syncColumnWidths() {
        let widths = listView.resolvedColumnWidths
        let cols = listView.columns
        for (let i = 0; i < contentRow.children.length && i < widths.length; i++) {
            contentRow.children[i].width = widths[i]
            if (cols[i] && typeof contentRow.children[i].horizontalAlignment !== 'undefined')
                contentRow.children[i].horizontalAlignment = cols[i].alignment
        }
    }

    Component.onCompleted: syncColumnWidths()

    Connections {
        target: listView
        function onResolvedColumnWidthsChanged() { syncColumnWidths() }
    }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }
}
