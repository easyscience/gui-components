import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

ListView {
    id: listView

    // ── Public API ──────────────────────────────────────────────────────
    // Properties and functions for consumers instantiating this component.

    width: EaStyle.Sizes.sideBarContentWidth

    // When true, rows use 1.5x height.
    property bool tallRows: false

    // Max visible rows before scrolling kicks in.
    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow

    // Text shown when ListView model is empty.
    property alias defaultInfoText: defaultInfoLabel.text

    // Scroll bar display mode.
    // Internally, use enum type name: ScrollBarMode.Indicator, etc.
    // Externally, use full module path: EaComponents.ListView.ScrollBarMode.Indicator, etc.
    // Cannot use id (listView.Indicator) — enums are type-scoped, not instance-scoped.
    // Cannot use ListView.Indicator — resolves to QtQuick's ListView, not this component.
    enum ScrollBarMode {
        Indicator,
        AsNeeded,
        AlwaysOn
    }
    property int scrollBarMode: ScrollBarMode.Indicator

    // Allow ctrl/shift multi-select.
    property bool multiSelection: true

    // Claim the enclosing FocusScope's default focus target.
    focus: true

    // Drives whether the delegate renders selection/anchor visuals.
    // Default: this list's own activeFocus. When hosted inside a FocusScope
    // with focusable siblings (buttons, filters), override with the scope's
    // activeFocus so visuals stay lit while focus is elsewhere in the panel,
    // e.g. `selectionActive: myScope.activeFocus`.
    property bool selectionActive: activeFocus

    // Column widths definition. Each entry is a width in px, or -1 to fill remaining space.
    // Example: columnWidths: [40, -1, 100]
    property var columnWidths: []

    // Clear all selection and reset anchor.
    function clearSelection() {
        selectionModel.clearSelection()
        anchorRow = -1
    }

    // ── Companion API ───────────────────────────────────────────────────
    // Used by ListViewHeader and ListViewDelegate. Not intended for direct consumer use.

    // Anchor row index for shift-selection range tracking.
    // Used by: ListViewDelegate (anchor indicator when row is not selected)
    property int anchorRow: -1

    // Row height in px, derived from tallRows.
    // Used by: ListViewDelegate (implicitHeight), ListViewHeader (own height)
    property int tableRowHeight: tallRows ?
                                     1.5 * EaStyle.Sizes.tableRowHeight :
                                     EaStyle.Sizes.tableRowHeight

    // Current selection state.
    // Used by: ListViewDelegate (binding dependency for row color)
    readonly property var selectedIndexes: selectionModel.selectedIndexes

    // Computed px widths from columnWidths.
    // Used by: ListViewHeader + ListViewDelegate (subscribe via onResolvedColumnWidthsChanged)
    readonly property var resolvedColumnWidths: {
        if (!columnWidths.length) return []
        let fixed = 0, flexCount = 0
        for (let w of columnWidths) {
            if (w > 0) fixed += w
            else flexCount++
        }
        const spacing = EaStyle.Sizes.tableColumnSpacing * (columnWidths.length - 1)
        const border = EaStyle.Sizes.borderThickness * 2
        const fill = flexCount > 0 ? Math.max(0, (width - fixed - spacing - border) / flexCount) : 0
        return columnWidths.map(w => w > 0 ? w : fill)
    }

    // Apply resolvedColumnWidths to children of a Row item.
    // Used by: ListViewHeader + ListViewDelegate (onCompleted + onResolvedColumnWidthsChanged)
    function applyWidths(row) {
        for (let i = 0; i < row.children.length && i < resolvedColumnWidths.length; i++)
            row.children[i].width = resolvedColumnWidths[i]
    }

    // Check if given row index is selected.
    // Used by: ListViewDelegate (row background color)
    function isSelected(row) {
        let idx = _index(row)
        return idx && idx.valid ? selectionModel.isSelected(idx) : false
    }

    // Select row with ctrl/shift modifier logic.
    // Used by: ListViewDelegate (MouseArea.onClicked)
    function selectWithModifiers(row, modifiers) {
        let idx = _index(row)
        if (!idx) return

        // SHIFT: range selection
        if (listView.multiSelection && modifiers & Qt.ShiftModifier) {
            if (anchorRow < 0) {
                anchorRow = row
            }

            let savedAnchor = anchorRow
            let from = Math.min(anchorRow, row)
            let to = Math.max(anchorRow, row)

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

        // CTRL: toggle
        if (listView.multiSelection && modifiers & Qt.ControlModifier) {
            selectionModel.select(
                idx,
                ItemSelectionModel.Toggle | ItemSelectionModel.Rows
            )
            anchorRow = row
            return
        }

        // DEFAULT: single selection
        selectionModel.select(
            idx,
            ItemSelectionModel.ClearAndSelect | ItemSelectionModel.Rows
        )
        anchorRow = row
    }

    // ── Internals ───────────────────────────────────────────────────────

    // Convert row int to QModelIndex for selectionModel.
    function _index(row) {
        if (!selectionModel.model || row < 0 || row >= count)
            return null
        return selectionModel.model.index(row, 0)
    }

    // Fixes clicks not registering right after scroll.
    pressDelay: 10

    property bool hasMoreRows: count > maxRowCountShow
    property real visibleRowCount: hasMoreRows ? maxRowCountShow + 0.5 : count
    // headerItem is non-null when a header delegate is set (e.g. ListViewHeader).
    // Uses actual headerItem.height so custom headers with different heights work.
    property real _headerHeight: headerItem ? headerItem.height : 0
    height: count === 0
                ? 2 * EaStyle.Sizes.tableRowHeight
                : tableRowHeight * visibleRowCount + _headerHeight

    clip: true
    headerPositioning: ListView.OverlayHeader
    boundsBehavior: Flickable.StopAtBounds
    enabled: count > 0

    highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
    highlight: Rectangle {
        z: 2
        color: mouseHoverHandler.hovered ?
                   EaStyle.Colors.tableHighlight :
                   "transparent"
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }

    // Any tap on the list (header, delegates, empty area) claims focus.
    // Non-blocking: delegate MouseAreas and header interactions still fire.
    TapHandler {
        acceptedDevices: PointerDevice.AllDevices
        onTapped: listView.forceActiveFocus()
    }

    ScrollBar.vertical: EaElements.ScrollBar {
        // ScrollBarMode enum not in scope inside child objects; use int values.
        // AlwaysOn=2, AsNeeded=1
        policy: listView.scrollBarMode === 2 ? ScrollBar.AlwaysOn
              : listView.scrollBarMode === 1 ? ScrollBar.AsNeeded
              : ScrollBar.AlwaysOff
        topInset: listView._headerHeight
        topPadding: listView.padding + listView._headerHeight
    }

    ScrollIndicator.vertical: EaElements.ScrollIndicator {
        // Indicator=0
        active: listView.scrollBarMode === 0
        topInset: listView._headerHeight
        topPadding: listView.padding + listView._headerHeight
    }

    // Empty-state label.
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

    // Table border, z above all content.
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

        onSelectionChanged: {
            if (selectedIndexes.length === 0)
                listView.anchorRow = -1
        }
    }
}
