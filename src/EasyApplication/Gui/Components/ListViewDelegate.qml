import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

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

    // Selection for the base row fill. Suppressed during editing so the
    // editor isn't drawn over the highlight color.
    readonly property bool selected: inSelection && !editing

    implicitWidth: listView.width
    implicitHeight: listView.tableRowHeight

    color: {
        let selectedColor = EaStyle.Colors.themeRowHighlight
        let evenRowColor = EaStyle.Colors.themeBackgroundHovered2
        let oddRowColor = EaStyle.Colors.themeBackgroundHovered1
        let alternatingColor = index % 2 ? evenRowColor : oddRowColor

        return control.selected ? selectedColor : alternatingColor
    }
    Behavior on color { EaAnimations.ThemeChange {} }

    // Vertical accent bar on the left edge. Dual-purpose:
    //   - inSelection → solid themeAccent (selection indicator, persists
    //     during inline editing so the selected row stays identifiable).
    //   - shift-selection anchor row (not selected, not editing)
    //     → themeAccentMinor (replaces the former top-right triangle).
    // z:2 keeps the bar above the hover overlay (z:1) so selection
    // remains visible while hovering.
    Rectangle {
        z: 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: EaStyle.Colors.themeAccent
        visible: {
            listView.selectedIndexes
            if (control.inSelection) return true
            return listView.selectionActive
                && index === listView.anchorRow
                && !editing
        }
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    Component.onCompleted: if (listView) listView.applyWidths(contentRow)

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
        color: control.inSelection && !editing
            ? EaStyle.Colors.themeRowHighlightHovered
            : EaStyle.Colors.themeRowHovered
        opacity: mouseHoverHandler.hovered || editing ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: EaStyle.Sizes.tableHighlightMoveDuration } }
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    FocusScope {
        id: editScope
        anchors.fill: parent

        Row {
            id: contentRow

            height: parent.height
            spacing: EaStyle.Sizes.tableColumnSpacing
            leftPadding: listView ? listView.rowPadding : 0
            rightPadding: listView ? listView.rowPadding : 0
        }
    }

    // TapHandler (not MouseArea) so nested interactive children like
    // TableViewButton receive their own press events — MouseArea's
    // exclusive grab on press would swallow clicks on those buttons.
    TapHandler {
        id: tap
        onTapped: {
            if (index < 0) return
            listView.currentIndex = index
            // Tap lands on the row background (cell editors swallow their
            // own press). Release any in-progress edit before updating
            // selection so editor visuals drop on row-background clicks.
            listView.endEditing()
            listView.selectWithModifiers(index, tap.point.modifiers)
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
