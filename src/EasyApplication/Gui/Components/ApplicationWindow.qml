import QtQuick
import QtCore

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


EaElements.ApplicationWindow {
    id: appWindow

    property alias appBar: appBar
    property alias appBarLeftButtons: appBarLeftButtons.data
    property alias appBarCentralTabs: appBarCentralTabs
    property alias appBarRightButtons: appBarRightButtons.data
    property alias contentArea: contentArea.contentData
    property alias statusBar: statusBarContainer.data

    ////////////////
    // App container
    ////////////////

    Rectangle {
        id: appContainer

        anchors.fill: parent

        color: appWindow.color

        // Application bar container
        Rectangle {
            id: appBar

            anchors.top: appContainer.top
            anchors.left: appContainer.left
            anchors.right: appContainer.right
            height: EaStyle.Sizes.appBarHeight

            color: EaStyle.Colors.appBarBackground
            Behavior on color { EaAnimations.ThemeChange {} }

            EaComponents.AppBarLeftButtons {
                id: appBarLeftButtons

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: EaStyle.Sizes.fontPixelSize
            }

            EaComponents.AppBarCentralTabs {
                id: appBarCentralTabs

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                currentIndex: EaGlobals.Vars.appBarCurrentIndex
                onCurrentIndexChanged: EaGlobals.Vars.appBarCurrentIndex = currentIndex
            }

            EaComponents.AppBarRightButtons {
                id: appBarRightButtons

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: EaStyle.Sizes.fontPixelSize
            }

            // tabs bottom border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: EaStyle.Sizes.borderThickness
                color: EaStyle.Colors.appBarBorder
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }

        // Content area container
        EaComponents.ContentArea {
            id: contentArea

            anchors.top: appBar.bottom
            anchors.bottom: statusBarContainer.top
            anchors.left: appContainer.left
            anchors.right: appContainer.right

            currentIndex: appBarCentralTabs.currentIndex
        }

        // Status bar container
        Item {
            id: statusBarContainer

            anchors.bottom: appContainer.bottom
            anchors.left: appContainer.left
            anchors.right: appContainer.right
            height: EaStyle.Sizes.statusBarHeight
        }
    }

    ///////////////
    // Init dialogs
    ///////////////

    // Application dialogs (invisible at the beginning)
    EaComponents.PreferencesDialog {}

    ///////////
    // Settings
    ///////////

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'ApplicationWindow.Geometry'
        property alias x: appWindow.x
        property alias y: appWindow.y
        property alias width: appWindow.width
        property alias height: appWindow.height
    }

}
