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

    EaElements.ToolTip {
        text: control.ToolTip.text !== "" ? control.ToolTip.text : control.text
        visible: text !== "" && control.truncated && mouseHoverHandler.hovered && EaGlobals.Vars.showToolTips
    }

    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }
}
