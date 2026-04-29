import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Elements as EaElements

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

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }

}
