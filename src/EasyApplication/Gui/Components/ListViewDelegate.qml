import QtQuick

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations

Rectangle {
    id: control

    default property alias contentRowData: contentRow.data
    // Needs to be instantiated inside of a EaComponents.ListView, won't work otherwise
    property Item listView: ListView.view

    // True while any focusable cell inside the row (typically a TextInput)
    // owns activeFocus. Aggregated by the FocusScope wrapping contentRow.
    // The delegate also factors this into its own selection visuals so
    // inline editing isn't drawn over the accent row background.
    readonly property alias editing: editScope.activeFocus

    // Row is in the selection model. Reads selectedIndexes to create a
    // binding dependency so this re-evaluates when selection changes
    // (isSelected() alone isn't tracked by QML). Used for the left accent
    // bar and the hover overlay color — both stay selection-aware even
    // while an inline editor owns focus.
    readonly property bool inSelection: {
        listView.selectedIndexes
        return index >= 0
            && listView.isSelected(index)
            && listView.selectionActive
    }

    // Retained selection API; background paint is independent of selection.
    // Inline editing and selection remain separate.
    readonly property bool selected: inSelection && !editing

    implicitWidth: listView.width
    implicitHeight: listView.tableRowHeight

    // Selection never replaces the alternating row background.
    color: index % 2 ? EaStyle.Colors.themeBackgroundHovered2 : EaStyle.Colors.themeBackgroundHovered1
    Behavior on color { EaAnimations.ThemeChange {} }

    // Multiple selected rows and an unselected shift anchor retain individual
    // bars. The sole selected/current row uses the view's moving marker instead.
    // z:2 keeps these bars above the ordinary hover overlay.
    Rectangle {
        z: 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: EaStyle.Sizes.borderThickness
        width: 2
        color: EaStyle.Colors.themeAccent
        visible: {
            listView.selectedIndexes
            if (control.inSelection)
                return listView.selectedIndexes.length > 1
                    || (listView.currentRow >= 0 && index !== listView.currentRow)
            return listView.selectionActive
                && index === listView.anchorRow
                && !editing
        }
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    readonly property int rowIndex: index
    // The row the view's moving accent marker is on (its current row, or its one
    // selected row). A row-number cell (ListViewLabel.marksCurrentRow) reads it.
    readonly property bool current: listView !== null && index >= 0 && listView.markerRow === index
    onRowIndexChanged: if (listView) listView.refreshMarker()
    onYChanged: if (listView) listView.refreshMarker()
    onHeightChanged: if (listView) listView.refreshMarker()
    Component.onCompleted: {
        const view = listView
        if (!Qt.isQtObject(view)) return
        view.applyWidths(contentRow)
        if (Qt.isQtObject(control) && Qt.isQtObject(view) && control.listView === view)
            view.refreshMarker()
    }

    // A cell editor (e.g. ListViewTextInput) claiming activeFocus flips
    // `editing` true. Mirror that into the row selection so the edited
    // row is also the selected row.
    onEditingChanged: {
        if (editing && index >= 0 && !control.inSelection && listView.selectOnEdit) {
            listView.selectWithModifiers(index, Qt.NoModifier)
        }
    }

    Connections {
        target: listView
        function onResolvedColumnWidthsChanged() { listView.applyWidths(contentRow) }
    }

    // Hover tint. Lives in the delegate so position is implicit from the
    // delegate's own bounds — no y math, no uniform-row-height assumption.
    Rectangle {
        anchors.fill: parent
        color: EaStyle.Colors.themeRowHovered
        opacity: mouseHoverHandler.hovered || editing ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: EaStyle.Sizes.tableHighlightMoveDuration } }
        Behavior on color { EaAnimations.ThemeChange {} }
        // Background input stays behind the editor scope. Unlike a passive
        // ancestor TapHandler, it does not also handle an accepted cell click.
        MouseArea {
            anchors.fill: parent
            cursorShape: undefined
            onClicked: mouse => {
                if (index < 0) return
                listView.currentIndex = index
                listView.endEditing()
                listView.selectWithModifiers(index, mouse.modifiers)
            }
        }
    }

    FocusScope {
        id: editScope
        anchors.fill: parent

        Row {
            id: contentRow

            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            spacing: EaStyle.Sizes.tableColumnSpacing
            leftPadding: listView ? listView.rowPadding : 0
            rightPadding: listView ? listView.rowPadding : 0
        }
    }

    // Visual-only hover tracking. Writes to listView.hoveredIndex, never
    // currentIndex or selectionModel — keeping those independent prevents
    // hover from stealing activeFocus from inline editors (e.g. TextInput)
    // in a different row during editing.
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        cursorShape: Qt.PointingHandCursor
        blocking: false
    }
}
