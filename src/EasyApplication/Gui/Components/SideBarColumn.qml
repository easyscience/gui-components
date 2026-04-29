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

    clip: true
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
