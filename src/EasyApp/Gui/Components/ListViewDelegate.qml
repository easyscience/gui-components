import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    id: control

    default property alias contentRowData: contentRow.data
    property Item listView: ListView.view ?? null

    // True while any focusable cell inside the row (typically a TextInput)
    // owns activeFocus. Aggregated by the FocusScope wrapping contentRow.
    // The delegate also factors this into its own selection visuals so
    // inline editing isn't drawn over the accent row background.
    readonly property alias editing: editScope.activeFocus

    implicitWidth: listView.width
    implicitHeight: listView.tableRowHeight

    color: {
        // Read selectedIndexes to create a binding dependency — forces
        // this color expression to re-evaluate whenever the selection changes.
        listView.selectedIndexes

        let selected = index >= 0 && listView.isSelected(index) && listView.selectionActive && !editing

        let selectedColor = EaStyle.Colors.themeAccentMinor
        let evenRowColor = EaStyle.Colors.themeBackgroundHovered2
        let oddRowColor = EaStyle.Colors.themeBackgroundHovered1
        let alternatingColor = index % 2 ? evenRowColor : oddRowColor

        return selected ? selectedColor : alternatingColor
    }
    Behavior on color { EaAnimations.ThemeChange {} }

    Component.onCompleted: if (listView) listView.applyWidths(contentRow)

    Connections {
        target: listView
        function onResolvedColumnWidthsChanged() { listView.applyWidths(contentRow) }
    }

    // Hover tint. Lives in the delegate so position is implicit from the
    // delegate's own bounds — no y math, no uniform-row-height assumption.
    Rectangle {
        anchors.fill: parent
        color: EaStyle.Colors.tableHighlight
        opacity: listView && listView.hoveredIndex === index ? 1 : 0
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

    // Anchor indicator: small triangle in top-right corner when row is
    // the shift-selection anchor but not currently selected.
    Item {
        visible: {
            // Read selectedIndexes to create binding dependency for reactivity.
            listView.selectedIndexes
            return listView.selectionActive
                   && index === listView.anchorRow
                   && !listView.isSelected(index)
                   && !editing
        }
        anchors.top: parent.top
        anchors.right: parent.right
        width: 8
        height: 8
        clip: true
        layer.enabled: true
        layer.smooth: false

        Rectangle {
            width: parent.width * 1.5
            height: parent.height * 1.5
            rotation: 45
            x: Math.round(parent.width / 2)
            y: Math.round(-parent.height * 0.75)
            antialiasing: false
            color: EaStyle.Colors.themeAccentMinor
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }

    // TapHandler (not MouseArea) so nested interactive children like
    // TableViewButton receive their own press events — MouseArea's
    // exclusive grab on press would swallow clicks on those buttons.
    TapHandler {
        id: tap
        onTapped: {
            if (index >= 0) {
                listView.forceActiveFocus()
                listView.selectWithModifiers(index, tap.point.modifiers)
            }
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
        onHoveredChanged: {
            if (index < 0) return
            if (hovered)
                listView.hoveredIndex = index
            else if (listView.hoveredIndex === index)
                listView.hoveredIndex = -1
        }
    }
}
