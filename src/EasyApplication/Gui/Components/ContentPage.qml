import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

Item {
    id: page

    property string defaultInfo: ""
    property alias mainView: mainViewContainer.data
    property alias sideBar: sideBarContainer.data

    // Main content
    Item {
        id: mainViewContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: sideBarContainer.left

        clip: true
    }

    // Defaul info box
    Rectangle {
        visible: defaultInfo !== ""
        anchors.top: mainViewContainer.top
        anchors.bottom: mainViewContainer.bottom
        anchors.left: mainViewContainer.left
        anchors.right: mainViewContainer.right

        color: EaStyle.Colors.contentBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            enabled: false
            anchors.centerIn: parent
            font.family: EaStyle.Fonts.secondFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
            font.weight: Font.ExtraLight
            text: defaultInfo
        }
    }

    // Sidebar container
    Item {
        id: sideBarContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.right: page.right
        //width: childrenRect.width === border.width ? 0 : EaStyle.Sizes.sideBarWidth
        width: EaStyle.Sizes.sideBarWidth

        clip: true

        // Vertical border on the left side
        Rectangle {
            id: border

            z: 2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: EaStyle.Sizes.borderThickness

            color: EaStyle.Colors.appBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }
}
