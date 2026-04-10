import QtQuick
import QtQuick.Controls as QC

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

QC.ListView {
    id: listView
    width: EaStyle.Sizes.sideBarContentWidth

    property bool showHeader: true
    property bool tallRows: false
    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    property int tableRowHeight: tallRows ?
                                     1.5 * EaStyle.Sizes.tableRowHeight :
                                     EaStyle.Sizes.tableRowHeight
    property alias defaultInfoText: defaultInfoLabel.text
    

    enum ScrollBarMode {
        Indicator,
        AsNeeded,
        AlwaysOn
    }
    property int scrollBarMode: ListView.Indicator

    // flag to limit selections
    property bool multiSelection: true

    // used to bind delegate colors to current selections
    readonly property var selectedIndexes: selectionModel.selectedIndexes

    // Column widths definition. Each entry is a width in px, or -1 to fill remaining space.
    // Example:
    // columnWidths: [40, -1, 100]
    property var columnWidths: []
    readonly property var resolvedColumnWidths: {
        if (!columnWidths.length) return []
        let fixed = 0, flexCount = 0
        for (let w of columnWidths) {
            if (w > 0) fixed += w
            else flexCount++
        }
        const spacing = EaStyle.Sizes.tableColumnSpacing * (columnWidths.length - 1)
        const border = EaStyle.Sizes.borderThickness * 2
        // Remaining space after fixed columns, inter-column spacing, and border,
        // divided equally among flex columns (width: -1). Clamped to 0.
        const fill = flexCount > 0 ? Math.max(0, (width - fixed - spacing - border) / flexCount) : 0
        return columnWidths.map(w => w > 0 ? w : fill)
    }

    // idx for shift-selection
    property int anchorRow: -1

    
    // fixes an issue of clicks not registering right after scroll
    pressDelay: 10

    property bool hasMoreRows: count > maxRowCountShow
    property real visibleRowCount: hasMoreRows ? maxRowCountShow + 0.5 : count
    height: count === 0
                ? 2 * EaStyle.Sizes.tableRowHeight
                : showHeader
                    ? tableRowHeight * (visibleRowCount + 1)
                    : tableRowHeight * visibleRowCount

    clip: true
    headerPositioning: QC.ListView.OverlayHeader
    boundsBehavior: Flickable.StopAtBounds
    enabled: count > 0
    // Highlight current row
    highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
    highlight: Rectangle {
        z: 2 // To display highlight rect above delegate
        color: mouseHoverHandler.hovered ?
                   EaStyle.Colors.tableHighlight :
                   "transparent"
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // Hide current row highlight if table is not hovered
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }

    QC.ScrollBar.vertical: EaElements.ScrollBar {
        policy: scrollBarMode === ListView.AlwaysOn  ? QC.ScrollBar.AlwaysOn
              : scrollBarMode === ListView.AsNeeded  ? QC.ScrollBar.AsNeeded
              : QC.ScrollBar.AlwaysOff
        topInset: listView.showHeader ? listView.tableRowHeight : 0
        topPadding: listView.padding + (listView.showHeader ? listView.tableRowHeight : 0)
    }

    QC.ScrollIndicator.vertical: EaElements.ScrollIndicator {
        active: scrollBarMode === ListView.Indicator
        topInset: listView.showHeader ? listView.tableRowHeight : 0
        topPadding: listView.padding + (listView.showHeader ? listView.tableRowHeight : 0)
    }

    // Default info, if no rows added.
    // Parented directly to listView so it doesn't scroll with content.
    Rectangle {
        parent: listView
        visible: listView.count === 0
        width: listView.width
        height: EaStyle.Sizes.tableRowHeight * 2
        color: EaStyle.Colors.themeBackground

        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            id: defaultInfoLabel

            anchors.verticalCenter: parent.verticalCenter
            leftPadding: EaStyle.Sizes.fontPixelSize
        }
    }

    // Table border, z above all content (header z:3, highlight z:2).
    // Parented directly to listView so it doesn't scroll with content.
    Rectangle {
        parent: listView
        z: 4
        anchors.fill: parent
        color: "transparent"
        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    ItemSelectionModel {
        id: selectionModel
        model: listView.model
    }

    Connections {
        target: selectionModel

        function onSelectionChanged() {
            if (selectionModel.selectedIndexes.length === 0)
                anchorRow = -1
        }
    }

    function applyWidths(row) {
        for (let i = 0; i < row.children.length && i < resolvedColumnWidths.length; i++)
            row.children[i].width = resolvedColumnWidths[i]
    }

    // --- helper: convert row -> QModelIndex ---
    function _index(row) {
        if (!selectionModel.model || row < 0 || row >= count)
            return null
        return selectionModel.model.index(row, 0)
    }

    // --- public API ---
    function isSelected(row) {
        let idx = _index(row)
        return idx && idx.valid ? selectionModel.isSelected(idx) : false
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

            // If Ctrl is NOT pressed -> replace selection
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
}
