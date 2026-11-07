import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements


Flickable {

    default property alias content: column.data
    readonly property int childrenCount: column.children.length

    //enabled: childrenCount

    contentHeight: column.height
    contentWidth: column.width

    // Drawn through a layer: in the web build on Windows a clipped item crossing the edge of an enclosing
    // clip loses its own clip, and inside a layer it does not. The clip stays for input and visibility.
    clip: true
    layer.enabled: true
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: EaElements.ScrollBar {
        policy: ScrollBar.AsNeeded
        interactive: false
    }

    Column {
        id: column

        width: EaStyle.Sizes.sideBarWidth
    }

}
