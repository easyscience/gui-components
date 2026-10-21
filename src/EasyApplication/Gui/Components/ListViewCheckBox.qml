import QtQuick

import EasyApplication.Gui.Elements as EaElements

// A check box cell of a ListViewDelegate row, centred in its column.
EaElements.CheckBox {
    property int horizontalAlignment: Text.AlignHCenter

    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
}
