import QtQuick
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements


T.SpinBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth +
                            up.implicitIndicatorWidth +
                            down.implicitIndicatorWidth)
    implicitHeight: Math.max(implicitContentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight,
                             up.implicitIndicatorHeight,
                             down.implicitIndicatorHeight)

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: (mouse) => mouse.accepted = false
    }

    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        id: textInput

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints

        font: control.font
        text: control.displayText

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        color: foregroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }

        selectionColor: EaStyle.Colors.themeAccent
        Behavior on selectionColor { EaAnimations.ThemeChange {} }

        selectedTextColor: EaStyle.Colors.themeBackground
        Behavior on selectedTextColor { EaAnimations.ThemeChange {} }

        cursorDelegate: CursorDelegate { }
    }

    up.indicator: EaElements.SideBarButton {
        x: control.mirrored ? 0 : parent.width - width
        z: textInput.z + 1

        implicitWidth: EaStyle.Sizes.comboBoxHeight
        implicitHeight: EaStyle.Sizes.comboBoxHeight

        height: parent.height
        width: height

        radius: 0

        fontIcon: "plus"

        onClicked: control.increase()
    }

    down.indicator: EaElements.SideBarButton {
        x: control.mirrored ? parent.width - width : 0
        z: textInput.z + 1

        implicitWidth: EaStyle.Sizes.comboBoxHeight
        implicitHeight: EaStyle.Sizes.comboBoxHeight

        height: parent.height
        width: height

        radius: 0

        fontIcon: "minus"

        onClicked: control.decrease()
    }

    background: Item {
        implicitWidth: EaStyle.Sizes.comboBoxHeight * 2 + EaStyle.Sizes.fontPixelSize * 4
        implicitHeight: EaStyle.Sizes.comboBoxHeight

        Rectangle {
            anchors.fill: parent

            color: backgroundColor()
            Behavior on color { EaAnimations.ThemeChange {} }

            border.color: borderColorTop()
            Behavior on border.color { EaAnimations.ThemeChange {} }
        }

        // Bottom border
        Rectangle {
            x: parent.width / 2 - width / 2
            y: parent.y + parent.height - height - control.bottomPadding / 2
            width: control.availableWidth
            height: control.activeFocus ? 2 : 1

            color: borderColorBottom()
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }

    // Logic

    function backgroundColor() {
        if (!control.hovered)
            return EaStyle.Colors.appBarComboBoxBackground
        if (control.pressed)
            return EaStyle.Colors.appBarComboBoxBackgroundPressed
        return EaStyle.Colors.appBarComboBoxBackgroundHovered
    }

    function foregroundColor() {
        if (!enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseArea.containsMouse || control.activeFocus)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

    function borderColorTop() {
        if (!enabled)
            return EaStyle.Colors.themeForegroundDisabled
        return EaStyle.Colors.appBarComboBoxBorder
    }

    function borderColorBottom() {
        if (!enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseArea.containsMouse || control.activeFocus)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.appBarComboBoxBorder
    }
}
