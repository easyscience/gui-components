import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

Item {
    id: newTableView
    height: count === 0 ?
                2 * EaStyle.Sizes.tableRowHeight :
                showHeader ?
                    nestedTableView.tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    nestedTableView.tableRowHeight * (Math.min(count, maxRowCountShow))
    width: EaStyle.Sizes.sideBarContentWidth

    // exposing underlying tableview API
    property alias count: nestedTableView.count
    property alias showHeader: nestedTableView.showHeader
    property alias tallRows: nestedTableView.tallRows
    property alias maxRowCountShow: nestedTableView.maxRowCountShow
    property alias defaultInfoText: nestedTableView.defaultInfoText
    property alias header: nestedTableView.header
    property alias model: nestedTableView.model
    property alias delegate: nestedTableView.delegate

    // trigger for bindings
    property int selectionRevision: 0
    // idx for shift-selection
    property int anchorRow: -1

    ItemSelectionModel {
        id: selectionModel
        model: nestedTableView.model
    }

    Connections {
        target: selectionModel

        function onSelectionChanged() {
            newTableView.selectionRevision++
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
        if (modifiers & Qt.ShiftModifier) {
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
        if (modifiers & Qt.ControlModifier) {
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

    // ScrollView{
    //     width: nestedTableView.width
    //     height: nestedTableView.height

    //     ScrollBar.vertical: EaElements.ScrollBar {
    //                 id: scrollBar
    //                 anchors.right: parent.right
    //                 // anchors.top: parent.header.bottom
    //                 topPadding: parent.showHeader ? parent.tableRowHeight : 0
    //                 background.anchors.top: parent.parent.header.bottom
    //                 //anchors.bottom: parent.bottom
    //                 policy: ScrollBar.AlwaysOn //  ScrollBar.AsNeeded
    //                 width: 6
    //             }

    EaComponents.TableView {
        id: nestedTableView
        clip: true
        antialiasing: true
        anchors {
            fill: parent
            margins: 1
            // rightMargin: 1 // scrollBar.width
        }

        ScrollBar.vertical: EaElements.ScrollBar {
            id: scrollBar
            // anchors.right: parent.right
            // anchors.top: parent.header.bottom
            topInset: parent.showHeader ? parent.tableRowHeight : 0
            background.anchors.top: parent.parent.header.bottom
            //anchors.bottom: parent.bottom
            policy: ScrollBar.AsNeeded //  ScrollBar.AsNeeded
            width: 6
        }

        // fixes an issue of clicks not registering right after scroll
        // does not give too much delay due to selection animation playing anyway
        // somehow value doesn't affect anything, just fixes the missing clicks issue
        // even 10000 delay doesn't create a long delay, just fixes the issue
        pressDelay: 10

    }

}
