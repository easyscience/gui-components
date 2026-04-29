import QtQuick
import QtQuick.Controls

import QtQuick.Window

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements


Window {
    id: splashScreen

    property alias appNamePrefix: appNamePrefixLabel.text
    property alias appNameSuffix: appNameSuffixLabel.text
    property alias appVersion: appVersionLabel.text
    property alias logoSource: splashScreenLogo.source

    property bool initialGuiCompleted: false
    property bool animationFinished: false

    visible: !animationFinished

    //x: Screen.width / 2 - width / 2
    //y: Screen.height / 2 - height / 2

    height: splashScreenLogoRect.height
    width: splashScreenLogoRect.width

    flags: Qt.FramelessWindowHint //Qt.Popup

    color: "transparent"

    // Splash screen logo with animation

    Rectangle {
        id: splashScreenLogoRect

        height: splashScreenLogo.anchors.topMargin +
                splashScreenLogo.height +
                splashScreenLogo.anchors.bottomMargin
        width: splashScreenLogo.anchors.leftMargin +
               splashScreenLogo.width +
               appNamePrefixLabel.anchors.leftMargin +
               appNamePrefixLabel.width +
               appNameSuffixLabel.width +
               appNameSuffixLabel.anchors.rightMargin

        color: EaStyle.Colors.appBarBackground
        radius: EaStyle.Sizes.fontPixelSize

        // Application logo
        Image {
            id: splashScreenLogo

            height: EaStyle.Sizes.fontPixelSize * 7
            width: EaStyle.Sizes.fontPixelSize * 7

            anchors.verticalCenter: parent.verticalCenter
            anchors.topMargin: EaStyle.Sizes.fontPixelSize * 1.5
            anchors.bottomMargin: EaStyle.Sizes.fontPixelSize * 1.5
            anchors.left: parent.left
            anchors.leftMargin: EaStyle.Sizes.fontPixelSize * 1.5

            fillMode: Image.PreserveAspectFit
            antialiasing: true

            RotationAnimation {
                id: splashScreenLogoAnimo

                target: splashScreenLogo

                running: !initialGuiCompleted
                alwaysRunToEnd: true

                loops: Animation.Infinite
                from: 0
                to: 360 * 6
                duration: 2000
                easing.type: Easing.OutInElastic

                onFinished: animationFinished = true
            }
        }

        // Application name prefix, e.g. `easy`
        EaElements.Label {
            id: appNamePrefixLabel

            anchors.left: splashScreenLogo.right
            anchors.leftMargin: EaStyle.Sizes.fontPixelSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -EaStyle.Sizes.fontPixelSize * 0.75

            font.family: EaStyle.Fonts.thirdFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 6
            font.weight: Font.Light
        }

        // Application name suffix, e.g. `diffraction`
        EaElements.Label {
            id: appNameSuffixLabel

            anchors.left: appNamePrefixLabel.right
            anchors.rightMargin: EaStyle.Sizes.fontPixelSize * 1.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -EaStyle.Sizes.fontPixelSize * 0.75

            font.family: EaStyle.Fonts.thirdFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 6
            font.weight: Font.DemiBold
        }

        // Application version
        EaElements.Label {
            id: appVersionLabel

            anchors.right: appNameSuffixLabel.right
            anchors.top: appNameSuffixLabel.bottom
            anchors.topMargin: -EaStyle.Sizes.fontPixelSize
            anchors.rightMargin: EaStyle.Sizes.fontPixelSize * 0.5
        }
    }

}
