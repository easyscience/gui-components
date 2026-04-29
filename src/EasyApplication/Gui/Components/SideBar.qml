import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements

Item {
    id: sideBarContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    property alias continueButton: continueButton

    anchors.fill: parent

    // Sidebar tabs
    EaElements.TabBar {
        id: tabs

        anchors.top: sideBarContainer.top
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right
    }
    // Sidebar tabs

    // Sidebar content
    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: continueButton.visible ?
                            continueButton.top:
                            sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        anchors.bottomMargin: EaStyle.Sizes.fontPixelSize

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }
    // Sidebar content

    // Continue button
    EaElements.SideBarButton {
        id: continueButton

        showBackground: false

        anchors.bottom: sideBarContainer.bottom
        anchors.horizontalCenter: sideBarContainer.horizontalCenter

        anchors.bottomMargin: 0.5 * EaStyle.Sizes.fontPixelSize

        fontIcon: "arrow-circle-right"
        text: qsTr("Continue")
    }
    // Continue button

    // Gradient area above button
    Rectangle {
        height: 1.25 * EaStyle.Sizes.fontPixelSize
        anchors.bottom: continueButton.top
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        anchors.bottomMargin: 0.85 * EaStyle.Sizes.fontPixelSize
        anchors.leftMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize

        //color: 'coral'
        //opacity: 0.5

        gradient: Gradient{
            GradientStop{ position : 0.0; color: `${EaStyle.Colors.contentBackground}`.replace('#', '#00')}
            GradientStop{ position : 1.0; color: `${EaStyle.Colors.contentBackground}`.replace('#', '#ff')}
        }
    }
    // Gradient area above button

}
