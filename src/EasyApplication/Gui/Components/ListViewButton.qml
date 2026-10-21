import QtQuick

import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Style as EaStyle

// A button cell of a ListViewDelegate row (an icon button such as remove),
// one row high and centred in its column.
EaElements.TabButton {
    property int horizontalAlignment: Text.AlignHCenter

    topInset: 3
    bottomInset: 3
    leftInset: 2
    rightInset: 2

    height: parent ? parent.height : EaStyle.Sizes.tableRowHeight
    width: EaStyle.Sizes.tableRowHeight
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined

    borderColor: EaStyle.Colors.chartAxis
}
