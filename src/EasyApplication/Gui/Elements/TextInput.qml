import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements


T.TextField {
    id: control

    property bool warned: false
    property bool selected: false
    property bool minored: false
    property bool enterFlash: false

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset ||
                   Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    selectByMouse: true

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize
    font.bold: control.activeFocus ? true : false

    color: enterFlash ?
               EaStyle.Colors.themeForeground :
               warned ?
               EaStyle.Colors.red :
               !enabled || readOnly || minored ?
                   EaStyle.Colors.themeForegroundMinor :
                   focus || selected || mouseHoverHandler.hovered ?
                       EaStyle.Colors.themeForegroundHovered :
                       EaStyle.Colors.themeForeground
    Behavior on color { EaAnimations.ThemeChange {} }

    selectionColor: EaStyle.Colors.themeAccent
    Behavior on selectionColor { EaAnimations.ThemeChange {} }

    selectedTextColor: EaStyle.Colors.themeBackground
    Behavior on selectedTextColor { EaAnimations.ThemeChange {} }

    placeholderTextColor: EaStyle.Colors.themeForegroundDisabled
    Behavior on placeholderTextColor { EaAnimations.ThemeChange {} }

    cursorDelegate: EaElements.CursorDelegate {}

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
    }

    background: Rectangle {
        color: 'transparent'
    }

    onAccepted: {
        control.enterFlash = true
        enterFlashTimer.start()
    }

    // Visual feedback for the user that editing finish was accepted
    Timer {
        id: enterFlashTimer
        interval: 180
        onTriggered: control.enterFlash = false
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
        cursorShape: Qt.IBeamCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TextInput.qml] hovered`)
            }
        }
    }

}
