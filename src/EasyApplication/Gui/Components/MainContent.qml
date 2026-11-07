import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Elements as EaElements

Item {
    id: mainAreaContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    anchors.fill: parent

    EaElements.TabBar {
        id: tabs

        anchors.top: mainAreaContainer.top
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right
    }

    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: mainAreaContainer.bottom
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right

        // Drawn through a layer: in the web build on Windows a clipped item crossing the edge of an enclosing
        // clip loses its own clip, and inside a layer it does not. The clip stays for input and visibility.
        clip: true
        layer.enabled: true
        interactive: false

        currentIndex: tabs.currentIndex
    }

}
