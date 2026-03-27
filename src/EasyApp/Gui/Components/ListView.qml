import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

Item {
    id: listView
    height: count === 0 ?
                2 * EaStyle.Sizes.tableRowHeight :
                showHeader ?
                    nestedListView.tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    nestedListView.tableRowHeight * (Math.min(count, maxRowCountShow))
    width: EaStyle.Sizes.sideBarContentWidth

    // exposing underlying tableview API
    property alias count: nestedListView.count
    property alias showHeader: nestedListView.showHeader
    property alias tallRows: nestedListView.tallRows
    property alias maxRowCountShow: nestedListView.maxRowCountShow
    property alias defaultInfoText: nestedListView.defaultInfoText
    property alias header: nestedListView.header
    property alias model: nestedListView.model
    property alias delegate: nestedListView.delegate

    property ScrollBar verticalScrollBar: null
    property ScrollIndicator verticalScrollIndicator: null
    property bool multiSelection: false

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
    }

    EaComponents.TableView {
        id: nestedListView
        clip: true
        antialiasing: true
        anchors {
            fill: parent
            // margins: 1
            // rightMargin: 1 // scrollBar.width
        }

        ScrollBar.vertical: listView.verticalScrollBar
        ScrollIndicator.vertical: listView.verticalScrollIndicator

        // fixes an issue of clicks not registering right after scroll
        // does not give too much delay due to selection animation playing anyway
        // somehow value doesn't affect anything, just fixes the missing clicks issue
        // even 10000 delay doesn't create a long delay, just fixes the issue
        pressDelay: 10

    }

}
