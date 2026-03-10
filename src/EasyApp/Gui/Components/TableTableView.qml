import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents



Column {
    id: root

    property alias model: tableView.model
    property alias defaultInfoText: defaultInfoLabel.text

    property bool showHeader: true
    property bool tallRows: false

    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow

    property int tableRowHeight: tallRows
                                 ? 1.5 * EaStyle.Sizes.tableRowHeight
                                 : EaStyle.Sizes.tableRowHeight

    property var columnWidths: []
    property int flexibleColumn: -1

    width: EaStyle.Sizes.sideBarContentWidth

    height: {
        let rows = tableView.rows
        if (rows === 0)
            return 2 * EaStyle.Sizes.tableRowHeight

        let visibleRows = Math.min(rows, maxRowCountShow)
        return showHeader
                ? tableRowHeight * (visibleRows + 1)
                : tableRowHeight * visibleRows
    }

    spacing: 0

    enabled: tableView.rows > 0

    //
    // HEADER
    //

    HorizontalHeaderView {
        id: headerView

        visible: root.showHeader
        syncView: tableView

        height: root.tableRowHeight

        delegate: Rectangle {

            implicitHeight: root.tableRowHeight
            color: EaStyle.Colors.themeBackground

            Behavior on color { EaAnimations.ThemeChange {} }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: EaStyle.Sizes.fontPixelSize

                text: display
                horizontalAlignment: model.horizontalAlignment ?? Text.AlignLeft
            }
        }
    }

    //
    // TABLE
    //

    TableView {
        id: tableView

        clip: true

        boundsBehavior: Flickable.StopAtBounds

        columnSpacing: EaStyle.Sizes.tableColumnSpacing

        rowHeightProvider: function(row) {
            return root.tableRowHeight
        }

        columnWidthProvider: function(column) {

            if (column === root.flexibleColumn) {

                let fixed = 0

                for (let i = 0; i < root.columnWidths.length; i++) {
                    if (i !== root.flexibleColumn)
                        fixed += root.columnWidths[i]
                }

                let spacing = (columns - 1) * EaStyle.Sizes.tableColumnSpacing
                let border = EaStyle.Sizes.borderThickness * 2

                return root.width - fixed - spacing - border
            }

            return root.columnWidths[column]
        }

        delegate: Rectangle {

            required property int row
            required property int column

            implicitHeight: root.tableRowHeight

            color: {
                if (row === root.selectedRow)
                    return EaStyle.Colors.tableSelection
                if (mouseArea.containsMouse)
                    return EaStyle.Colors.tableHighlight
                return "transparent"
            }

            Behavior on color { EaAnimations.ThemeChange {} }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: EaStyle.Sizes.fontPixelSize

                text: display
            }

            TapHandler {
                onTapped: root.selectedRow = row
            }
        }
    }

    //
    // BORDER
    //

    Rectangle {
        anchors.fill: tableView
        color: "transparent"

        border.color: EaStyle.Colors.appBarComboBoxBorder

        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    //
    // EMPTY INFO
    //

    Rectangle {

        visible: tableView.rows === 0

        width: root.width
        height: EaStyle.Sizes.tableRowHeight * 2

        color: EaStyle.Colors.themeBackground

        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            id: defaultInfoLabel

            anchors.verticalCenter: parent.verticalCenter

            leftPadding: EaStyle.Sizes.fontPixelSize
        }
    }

    //
    // HOVER HANDLER
    //

    HoverHandler {
        id: mouseHoverHandler

        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }
}
