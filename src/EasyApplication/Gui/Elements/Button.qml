import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements


T.Button {
    id: control

    // An icon from the icon font, drawn before the text; every button in a popup has one.
    property string fontIcon: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    /*
    topInset: 0
    bottomInset: 0
    horizontalPadding: 0
    */

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    flat: true

    // Set by a caller whose label or icon already says what the button does: its tooltip then opens only at level All,
    // or while it is disabled.
    property bool toolTipSelfExplanatory: false

    // The button's one tooltip, asked for from the hover handler, which reports hover on a disabled button too. A
    // caller gives only its text.
    EaElements.ToolTip {
        text: control.ToolTip.text
        requested: mouseHoverHandler.hovered
        selfExplanatory: control.toolTipSelfExplanatory
    }

    // Icon text; an icon from the icon font sits just before the text, the text keeping its place otherwise.
    contentItem: IconLabel {
        readonly property real glyphPadding: control.fontIcon !== "" ? glyph.implicitWidth + EaStyle.Sizes.fontPixelSize * 0.5 : 0
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        leftPadding: glyphPadding

        icon: control.icon
        text: control.text
        font: control.font

        color: foregroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }

        Label {
            id: glyph
            visible: control.fontIcon !== ""
            x: (parent.width - parent.implicitWidth) / 2
            anchors.verticalCenter: parent.verticalCenter
            font.family: EaStyle.Fonts.iconsFamily
            font.pixelSize: control.font.pixelSize
            text: control.fontIcon
            color: foregroundColor()
        }
    }

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: control
        cursorShape: undefined  // prevents changing the cursor
        hoverEnabled: false
        onPressed: (mouse) => mouse.accepted = false
    }

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        cursorShape: control.checked ?
                         Qt.PointingHandCursor :
                         Qt.PointingHandCursor //ArrowCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TextInput.qml] hovered`)
            }
        }
    }


    // Logic

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseHoverHandler.hovered || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }
}
