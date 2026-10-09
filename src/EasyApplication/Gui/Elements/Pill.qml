import QtQuick

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements


Rectangle {
    id: pill

    property string text: ""
    property string fontIcon: ""
    property string removeTooltip: qsTr("Remove")
    signal removed()

    readonly property bool hasIcon: fontIcon !== ""

    height: textLabel.implicitHeight * 2
    width: EaStyle.Sizes.fontPixelSize
         + (hasIcon ? iconLabel.implicitWidth + EaStyle.Sizes.fontPixelSize * 0.5 : 0)
         + textLabel.implicitWidth
         + EaStyle.Sizes.fontPixelSize * 0.6
         + removeLabel.width
         + EaStyle.Sizes.fontPixelSize * 0.6
    radius: height / 2
    color: EaStyle.Colors.appBarBackground
    border.color: EaStyle.Colors.appBarComboBoxBorder
    border.width: 1

    Row {
        anchors.fill: parent
        anchors.leftMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: removeLabel.width + EaStyle.Sizes.fontPixelSize * 0.25
        spacing: EaStyle.Sizes.fontPixelSize * 0.5

        EaElements.Label {
            id: iconLabel
            visible: pill.hasIcon
            text: pill.fontIcon
            font.family: EaStyle.Fonts.iconsFamily
            anchors.verticalCenter: parent.verticalCenter
        }

        EaElements.Label {
            id: textLabel
            text: pill.text
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    EaElements.Label {
        id: removeLabel
        text: '×'
        font.pixelSize: EaStyle.Sizes.fontPixelSize * 1.4
        color: removeArea.containsMouse
               ? EaStyle.Colors.themeForegroundHovered
               : EaStyle.Colors.themeForegroundMinor
        anchors.right: parent.right
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize * 0.6
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            id: removeArea
            anchors.fill: parent
            anchors.margins: -EaStyle.Sizes.fontPixelSize * 0.3
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: pill.removed()
        }

        EaElements.ToolTip {
            text: pill.removeTooltip
            visible: removeArea.containsMouse && EaGlobals.Vars.showToolTips
        }
    }
}
