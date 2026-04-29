import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.RadioButton {
    id: control

    property color color: EaStyle.Colors.themeForeground

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: EaStyle.Sizes.fontPixelSize * 0.5
    padding: EaStyle.Sizes.fontPixelSize * 0.5
    verticalPadding: padding + EaStyle.Sizes.fontPixelSize * 0.5

    indicator: Rectangle {
        x: control.text ?
               (control.mirrored ?
                    control.width - width - control.rightPadding :
                    control.leftPadding) :
               control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        implicitWidth: EaStyle.Sizes.fontPixelSize
        implicitHeight: EaStyle.Sizes.fontPixelSize

        radius: width / 2
        border.width: 0.1 * EaStyle.Sizes.fontPixelSize

        color: "transparent"
        border.color: checked || mouseHoverHandler.hovered ?
                          EaStyle.Colors.themeForegroundHovered :
                          control.color
        Behavior on border.color { EaAnimations.ThemeChange {} }

        Rectangle {
            anchors.centerIn: parent

            implicitWidth: EaStyle.Sizes.touchSize
            implicitHeight: EaStyle.Sizes.touchSize

            radius: height * 0.5

            color: mouseHoverHandler.hovered ?
                       (mouseArea.containsPress ?
                            EaStyle.Colors.appBarButtonBackgroundPressed :
                            EaStyle.Colors.appBarButtonBackgroundHovered) :
                        EaStyle.Colors.appBarButtonBackground
            Behavior on color {
                PropertyAnimation {
                    duration: mouseArea.containsMouse ? 500 : 0
                    alwaysRunToEnd: true
                    easing.type: Easing.OutCubic
                }
            }

            //Mouse area to react on click events
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: undefined  // prevents changing the cursor
                hoverEnabled: false
                onPressed: (mouse) => mouse.accepted = false
            }

            // HoverHandler to react on hover events
            HoverHandler {
                id: mouseHoverHandler
                acceptedDevices: PointerDevice.AllDevices
                blocking: false
                cursorShape: Qt.PointingHandCursor
                onHoveredChanged: {
                    if (hovered) {
                        //console.error(`${control} [RadioButton.qml] hovered`)
                    }
                }
            }
        }

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            width: EaStyle.Sizes.fontPixelSize * 0.6
            height: EaStyle.Sizes.fontPixelSize * 0.6

            radius: width / 2

            visible: control.checked || control.down

            color: parent.border.color
        }
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ?
                         control.indicator.width + control.spacing -
                            EaStyle.Sizes.fontPixelSize * 0.2 :
                         0
        rightPadding: control.indicator && control.mirrored ?
                          control.indicator.width + control.spacing :
                          0

        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        color: control.enabled ?
                   EaStyle.Colors.themeForeground :
                   EaStyle.Colors.themeForegroundDisabled
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }
}
