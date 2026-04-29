import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements


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
