import QtQuick

import EasyApplication.Gui.Elements as EaElements

// A combo box cell of a ListViewDelegate row, drawn without a frame so the
// row's background shows through.
EaElements.ComboBox {
    property int horizontalAlignment: Text.AlignHCenter

    borderColor: "transparent"
    backgroundColor: "transparent"

    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
}
