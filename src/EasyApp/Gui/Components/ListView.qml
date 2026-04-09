import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

Item {
    id: listView
    height: nestedListView.height
    width: EaStyle.Sizes.sideBarContentWidth

    // exposing underlying tableview API
    property alias count: nestedListView.count
    property alias currentIndex: nestedListView.currentIndex
    property alias tableRowHeight: nestedListView.tableRowHeight
    property alias showHeader: nestedListView.showHeader
    property alias tallRows: nestedListView.tallRows
    property alias maxRowCountShow: nestedListView.maxRowCountShow
    property alias defaultInfoText: nestedListView.defaultInfoText
    property alias header: nestedListView.header
    // Must be a QAbstractItemModel (e.g. ListModel). JS arrays or integers
    // won't support selection.
    property alias model: nestedListView.model
    property alias delegate: nestedListView.delegate

    property alias hasMoreRows: nestedListView.hasMoreRows

    // Column widths definition. Each entry is a width in px, or -1 to fill remaining space. Example:
    // columnWidths: [40, -1, 100]
    property var columnWidths: []
    readonly property var resolvedColumnWidths: {
        if (!columnWidths.length) return []
        let fixed = 0, flexCount = 0
        for (let w of columnWidths)
            w > 0 ? fixed += w : flexCount++
        const spacing = EaStyle.Sizes.tableColumnSpacing * (columnWidths.length - 1)
        const border = EaStyle.Sizes.borderThickness * 2
        // Remaining space after fixed columns, inter-column spacing, and border,
        // divided equally among flex columns (width: -1). Clamped to 0.
        const fill = flexCount > 0 ? Math.max(0, (width - fixed - spacing - border) / flexCount) : 0
        return columnWidths.map(w => w > 0 ? w : fill)
    }

    function applyWidths(row) {
        for (let i = 0; i < row.children.length && i < resolvedColumnWidths.length; i++)
            row.children[i].width = resolvedColumnWidths[i]
    }

    property ScrollBar verticalScrollBar: null
    property ScrollIndicator verticalScrollIndicator: null

    // flag to limit selections
    property bool multiSelection: true

    // trigger for bindings
    property int selectionRevision: 0
    // idx for shift-selection
    property int anchorRow: -1

    ItemSelectionModel {
        id: selectionModel
        model: nestedListView.model
    }

    Connections {
        target: selectionModel

        function onSelectionChanged() {
            listView.selectionRevision++
            if (selectionModel.selectedIndexes.length === 0)
                anchorRow = -1
        }
    }

    // --- helper: convert row -> QModelIndex ---
    function _index(row) {
        if (!selectionModel.model)
            return null
        return selectionModel.model.index(row, 0)
    }

    // --- public API ---
    function isSelected(row) {
        let idx = _index(row)
        return idx ? selectionModel.isSelected(idx) : false
    }

    function selectWithModifiers(row, modifiers) {
        let idx = _index(row)
        if (!idx) return

        // --- SHIFT: range selection ---
        if (listView.multiSelection && modifiers & Qt.ShiftModifier) {
            if (anchorRow < 0) {
                anchorRow = row
            }

            let savedAnchor = anchorRow
            let from = Math.min(anchorRow, row)
            let to = Math.max(anchorRow, row)

            // If Ctrl is NOT pressed → replace selection
            if (!(modifiers & Qt.ControlModifier)) {
                selectionModel.clearSelection()
            }

            for (let i = from; i <= to; i++) {
                let rIdx = _index(i)
                if (rIdx) {
                    selectionModel.select(
                        rIdx,
                        ItemSelectionModel.Select | ItemSelectionModel.Rows
                    )
                }
            }

            anchorRow = savedAnchor
            return
        }

        // --- CTRL: toggle ---
        if (listView.multiSelection && modifiers & Qt.ControlModifier) {
            selectionModel.select(
                idx,
                ItemSelectionModel.Toggle | ItemSelectionModel.Rows
            )
            anchorRow = row
            return
        }

        // --- DEFAULT: single selection ---
        selectionModel.select(
            idx,
            ItemSelectionModel.ClearAndSelect | ItemSelectionModel.Rows
        )
        anchorRow = row
    }

    function clearSelection() {
        selectionModel.clearSelection()
        anchorRow = -1
    }

    ListView {
        id: nestedListView

        property alias defaultInfoText: defaultInfoLabel.text
        property bool showHeader: true
        property bool tallRows: false
        property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
        property int tableRowHeight: tallRows ?
                                         1.5 * EaStyle.Sizes.tableRowHeight :
                                         EaStyle.Sizes.tableRowHeight

        property bool hasMoreRows: count > maxRowCountShow
        property real visibleRowCount: hasMoreRows ? maxRowCountShow + 0.5 : count

        enabled: count > 0
        // fixes an issue of clicks not registering right after scroll
        pressDelay: 10

        width: parent.width
        height: count === 0
                    ? 2 * EaStyle.Sizes.tableRowHeight
                    : showHeader
                        ? tableRowHeight * (visibleRowCount + 1)
                        : tableRowHeight * visibleRowCount

        clip: true
        headerPositioning: ListView.OverlayHeader
        boundsBehavior: Flickable.StopAtBounds

        // Highlight current row
        highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
        highlight: Rectangle {
            z: 2 // To display highlight rect above delegate
            color: mouseHoverHandler.hovered ?
                       EaStyle.Colors.tableHighlight :
                       "transparent"
            Behavior on color { EaAnimations.ThemeChange {} }
        }

        // Default info, if no rows added
        Rectangle {
            visible: count === 0
            width: parent.width
            height: EaStyle.Sizes.tableRowHeight * 2
            color: EaStyle.Colors.themeBackground

            Behavior on color { EaAnimations.ThemeChange {} }

            EaElements.Label {
                id: defaultInfoLabel

                anchors.verticalCenter: parent.verticalCenter
                leftPadding: EaStyle.Sizes.fontPixelSize
            }
        }

        // Hide current row highlight if table is not hovered
        HoverHandler {
            id: mouseHoverHandler
            acceptedDevices: PointerDevice.AllDevices
            blocking: false
        }
    }

    // Table border, z above all content (header z:3, highlight z:2)
    Rectangle {
        z: 4
        anchors.fill: parent
        color: "transparent"
        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }
}
