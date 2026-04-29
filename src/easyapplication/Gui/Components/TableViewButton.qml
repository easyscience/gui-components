import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Style as EaStyle

EaElements.TabButton {
    property int horizontalAlignment: Text.AlignHCenter

    topInset: 3
    bottomInset: 3
    leftInset: 2
    rightInset: 2

    height: EaStyle.Sizes.tableRowHeight
    width: EaStyle.Sizes.tableRowHeight

    borderColor: EaStyle.Colors.chartAxis

}
