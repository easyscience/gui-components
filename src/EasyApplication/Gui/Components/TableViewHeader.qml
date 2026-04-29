import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    default property alias contentRowData: contentRow.data
    property Item tableView: parent.parent

    visible: tableView.showHeader

    z: 3 // To display header above delegate and highlighted area

    implicitWidth: parent === null ? 0 : parent.width
    implicitHeight: tableView.showHeader ? tableView.tableRowHeight : 0

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }
}
