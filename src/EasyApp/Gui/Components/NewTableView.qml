import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

Item {
    id: newTableView
    height: 200
    width: EaStyle.Sizes.sideBarContentWidth

    // exposing underlying tableview API
    property alias showHeader: nestedTableView.showHeader
    property alias tallRows: nestedTableView.tallRows
    property alias maxRowCountShow: nestedTableView.maxRowCountShow
    property alias defaultInfoText: nestedTableView.defaultInfoText
    property alias header: nestedTableView.header
    property alias model: nestedTableView.model
    property alias delegate: nestedTableView.delegate

    ItemSelectionModel {
        id: selectionModel
        model: nestedTableView.model
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

    function select(row) {
        let idx = _index(row)
        if (!idx)
            return

        selectionModel.select(
            idx,
            ItemSelectionModel.Select | ItemSelectionModel.Rows
        )
    }

    function selectSingle(row) {
        let idx = _index(row)
        if (!idx)
            return

        selectionModel.clearSelection()
        selectionModel.select(
            idx,
            ItemSelectionModel.Select | ItemSelectionModel.Rows
        )
    }

    function toggleSelection(row) {
        let idx = _index(row)
        if (!idx)
            return

        if (selectionModel.isSelected(idx)) {
            selectionModel.select(
                idx,
                ItemSelectionModel.Deselect | ItemSelectionModel.Rows
            )
        } else {
            selectionModel.select(
                idx,
                ItemSelectionModel.Select | ItemSelectionModel.Rows
            )
        }
    }

    function clearSelection() {
        selectionModel.clearSelection()
    }


    EaComponents.TableView {
        id: nestedTableView
        clip: true
        antialiasing: true
        anchors.fill: parent
        anchors.margins: 1

        delegate: EaComponents.TableViewDelegate {

            required property int index
            required property string name
            required property string structure_type
            required property string description

            color: newTableView.isSelected(index)
                   ? EaStyle.Colors.themeAccentMinor
                   : (index % 2
                        ? EaStyle.Colors.themeBackgroundHovered2
                        : EaStyle.Colors.themeBackgroundHovered1)

            EaComponents.TableViewLabel {
                id: modelNameColumn
                width: EaStyle.Sizes.fontPixelSize * 10
                text: name
                leftPadding: EaStyle.Sizes.fontPixelSize * 0.7
            }

            EaComponents.TableViewLabel {
                id: typeColumn
                width: EaStyle.Sizes.fontPixelSize * 6
                text: structure_type
            }

            EaComponents.TableViewLabel {
                id: descrColumn
                width: EaStyle.Sizes.fontPixelSize * 22
                text: description
            }

            mouseArea.onPressed: (mouse) => {
                newTableView.select(index)
            }
        }
    }
}
