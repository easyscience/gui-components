import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.Button {
    id: control

    property string fontIcon: ''
    property string minorText: ''
    property int horizontalAlignment: Text.AlignHCenter
    property int elide: Text.ElideMiddle

    //implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    padding: 0
    spacing: EaStyle.Sizes.fontPixelSize * 0.5
    anchors.verticalCenter: parent.verticalCenter

    checkable: false

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // contentItem
    contentItem: Item {
        width: control.width
        //implicitWidth: row.width
        implicitHeight: row.height

        // contentItem row layout
        Column {
            id: row
            spacing: control.spacing
            anchors.verticalCenter: parent.verticalCenter
            //anchors.fill: parent

            Row {
                spacing: control.spacing

                // icon
                Label {
                    visible: control.fontIcon
                    text: control.fontIcon

                    height: font.pixelSize
                    verticalAlignment: Text.AlignVCenter

                    font.family: EaStyle.Fonts.iconsFamily
                    font.pixelSize: control.font.pixelSize

                    color: control.checked ?  // || mouseHoverHandler.hovered ?
                               EaStyle.Colors.themeForegroundHovered :
                               EaStyle.Colors.themeForeground
                    Behavior on color { EaAnimations.ThemeChange {} }
                }
                // icon

                // text
                Label {
                    text: control.text

                    height: font.pixelSize
                    verticalAlignment: Text.AlignVCenter

                    font.family: control.font.family
                    font.pixelSize: control.font.pixelSize

                    color: control.checked ?  // || mouseHoverHandler.hovered ?
                               EaStyle.Colors.themeForegroundHovered :
                               EaStyle.Colors.themeForeground
                    Behavior on color { EaAnimations.ThemeChange {} }
                }
                // text

            }

            // minor text
            Label {
                id: valueLabel

                text: control.minorText

                height: font.pixelSize
                width: control.width - control.spacing // ???
                verticalAlignment: Text.AlignVCenter
                elide: control.elide

                textFormat: Text.RichText
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                color: EaStyle.Colors.statusBarTextForeground
                Behavior on color { EaAnimations.ThemeChange {} }

                EaAnimations.ColorReset {
                    id: colorResetAnimo

                    target: valueLabel
                    to: EaStyle.Colors.themeForeground
                }
            }
            // minor text

        }
        // contentItem row layout
    }
    // contentItem

    // background
    background: Rectangle {
        color: 'transparent'
    }
    // background

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TableViewTwoRowsAdvancedLabel.qml] hovered`)
            }
        }
    }

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: text !== "" &&
                 valueLabel.truncated &&
                 mouseHoverHandler.hovered &&
                 EaGlobals.Vars.showToolTips
    }
    // ToolTip

}
