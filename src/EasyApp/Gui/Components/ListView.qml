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
    property alias model: nestedListView.model
    property alias delegate: nestedListView.delegate

    property alias hasMoreRows: nestedListView.hasMoreRows

    property ScrollBar verticalScrollBar: null
    property ScrollIndicator verticalScrollIndicator: null
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

    ListView {
        id: nestedListView

        property alias defaultInfoText: defaultInfoLabel.text
        property bool showHeader: true
        property bool tallRows: false
        property var headerLabelItems: headerItem.children[0].children
        property int contentItemChildrenLength: contentItem.children.length
        property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
        property int tableRowHeight: tallRows ?
                                         1.5 * EaStyle.Sizes.tableRowHeight :
                                         EaStyle.Sizes.tableRowHeight

        property bool hasMoreRows: count > maxRowCountShow
        property real visibleRowCount: hasMoreRows ? maxRowCountShow + 0.5 : count

        enabled: count > 0

        width: EaStyle.Sizes.sideBarContentWidth
        height: count === 0
                    ? 2 * EaStyle.Sizes.tableRowHeight
                    : showHeader
                        ? tableRowHeight * (visibleRowCount + 1)
                        : tableRowHeight * visibleRowCount

        clip: true
        headerPositioning: ListView.OverlayHeader
        boundsBehavior: Flickable.StopAtBounds

        onHeaderLabelItemsChanged: setWidthOfFlexibleColumnForHeader()
        onContentItemChildrenLengthChanged: widthAndAlignmentChangeTimer.start()

        // Highlight current row
        highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
        highlight: Rectangle {
            z: 2 // To display highlight rect above delegate
            color: mouseHoverHandler.hovered ?
                       EaStyle.Colors.tableHighlight :
                       "transparent"
            Behavior on color { EaAnimations.ThemeChange {} }
        }

        // Empty header row
        //header: EaComponents.TableViewHeader {}

        // Empty content rows
        //delegate: EaComponents.TableViewDelegate {}

        // Table border
        Rectangle {
            anchors.fill: nestedListView
            color: "transparent"
            border.color: EaStyle.Colors.appBarComboBoxBorder
            Behavior on border.color { EaAnimations.ThemeChange {} }
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

        // Width and alignment change timer
        Timer {
            id: widthAndAlignmentChangeTimer
            interval: 10
            onTriggered: setAllColumnsWidthAndAlignment()
        }

        // HoverHandler to react on hover events
        // Hide current row highlight if table is not hovered
        HoverHandler {
            id: mouseHoverHandler
            acceptedDevices: PointerDevice.AllDevices
            blocking: false
            onHoveredChanged: {
                if (hovered) {
                    //console.error(`${nestedListView} [TableView.qml] hovered`)
                }
            }
        }

        // Logic

        function flexibleColumnWidth() {
            let fixedColumnsWidth = 0
            for (let item of headerLabelItems) {
                if (!item.flexibleWidth) {
                    fixedColumnsWidth += item.width
                }
            }
            const allColumnWidth = nestedListView.width
            const spacingWidth = EaStyle.Sizes.tableColumnSpacing * (headerLabelItems.length - 1)
            const borderThickness = EaStyle.Sizes.borderThickness * 2
            const flexibleColumnWidth = allColumnWidth -
                                      fixedColumnsWidth -
                                      spacingWidth -
                                      borderThickness
            return flexibleColumnWidth
        }

        function setWidthOfFlexibleColumnForHeader() {
            for (let item of headerLabelItems) {
                if (item.flexibleWidth) {
                    item.width = flexibleColumnWidth()
                }
            }
        }

        function setAllColumnsWidthAndAlignment() {
            for (let item of contentItem.children) {
                // Check for TableViewDelegate using explicit property
                if (item.toString().startsWith('TableViewDelegate_QMLTYPE')) {
                    const rowElement = item.children[0]
                    if (rowElement && rowElement.children) {
                        for (let columnIndex in rowElement.children) {
                            if (columnIndex < headerLabelItems.length) {
                                rowElement.children[columnIndex].width = headerLabelItems[columnIndex].width
                                if (typeof rowElement.children[columnIndex].horizontalAlignment !== 'undefined') {
                                    rowElement.children[columnIndex].horizontalAlignment = headerLabelItems[columnIndex].horizontalAlignment
                                }
                            }
                        }
                    }
                }
            }
        }

    }

}
