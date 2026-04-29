import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements

EaElements.Label {
    id: control

    property bool flexibleWidth: false
    readonly property alias hovered: mouseHoverHandler.hovered

    height: parent.height
    width: parent.height  // ???

    bottomInset: 4
    topInset: 4
    leftInset: 4
    rightInset: 4

    anchors.verticalCenter: parent.verticalCenter

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    elide: Text.ElideMiddle

    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: text !== "" &&
                 control.truncated &&
                 mouseHoverHandler.hovered &&
                 EaGlobals.Vars.showToolTips
    }

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TableViewLabel.qml] hovered`)
            }
        }
    }
}
