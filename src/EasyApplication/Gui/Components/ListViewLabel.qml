import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements

// A text cell of a ListViewHeader or ListViewDelegate row. Header and row cells
// are the same type, so their text has the same margins in every column.
EaElements.Label {
    id: control

    // A row-number cell: in the minor colour, and bold and in the accent colour
    // while its row is the list's current (marked) row, as the row's accent
    // marker is.
    property bool marksCurrentRow: false

    // The ListViewDelegate this cell is in; null in a header.
    readonly property Item row: {
        let item = parent
        while (item && !(item.rowIndex !== undefined && item.listView !== undefined))
            item = item.parent
        return item
    }
    readonly property bool currentRow: marksCurrentRow && row !== null && row.current

    readonly property alias hovered: mouseHoverHandler.hovered

    // What the cell would show with room, in its tooltip while `shortened` (by default while elided; a caller that
    // shows a value shorter than it is sets both), and the self-explanatory flag a caller sets on the cell.
    property string fullText: text
    property bool shortened: truncated
    property bool toolTipSelfExplanatory: false

    // The row's height; with no row yet, its own implicit height. Binding the height to
    // implicitHeight would make the text lay out in that height, which on macOS's
    // fractional line heights changed implicitHeight again: a binding loop.
    height: parent ? parent.height : undefined
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideMiddle

    font.bold: currentRow
    color: currentRow ?
               EaStyle.Colors.themeAccent :
               !enabled ?
                   EaStyle.Colors.themeForegroundDisabled :
                   marksCurrentRow ?
                       EaStyle.Colors.themeForegroundMinor :
                       selected ?
                           EaStyle.Colors.themeForegroundHovered :
                           EaStyle.Colors.themeForeground

    // The tool tip exists only while it can show. A table has a cell for every
    // row in view, and making a tool tip for each of them took a large share
    // of the time a long table took to appear.
    // The cell's one tooltip: help (ToolTip.text), fitting or not, and the full text while shortened.
    Loader {
        active: mouseHoverHandler.hovered && (control.ToolTip.text !== "" || control.shortened)
        sourceComponent: EaElements.ToolTip {
            parent: control
            text: EaGlobals.Vars.toolTipComposed(control.ToolTip.text, control.fullText, control.shortened)
            requested: true
            selfExplanatory: control.toolTipSelfExplanatory
        }
    }

    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }
}
