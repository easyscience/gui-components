import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic  // Fixes EasyApp/Gui/Elements/GroupBox.qml:51:22: QML Row: The current style does not support customization of this control (property: "contentItem" item: QQuickRow(0x60000381e200, parent=0x0, geometry=0,0 0x0)). Please customize a non-native style (such as Basic, Fusion, Material, etc). For more information, see: https://doc.qt.io/qt-6/qtquickcontrols2-customize.html#customization-reference
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Animations as EaAnimations


T.GroupBox {
    id: control

    property var titleArea: titleArea
    property string icon: ''
    property bool collapsible: true
    property bool collapsed: collapsible ? true : false
    property bool lastCollapsedState: collapsible ? true : false
    property bool last: {
        if (parent.children.length) {
            const lastGroupBox = parent.children[parent.children.length - 1]  // NEED FIX: Check if last item is GroupBox
            if (lastGroupBox === control) {
                return true
            }
            return false
        }
        return false
    }

    implicitWidth: parent.width
    implicitHeight: collapsed ?
                        titleArea.height :
                        titleArea.height + spacing + contentHeight + bottomPadding
    Behavior on implicitHeight { EaAnimations.ThemeChange { duration: 500 } }

    spacing: title === '' ? EaStyle.Sizes.fontPixelSize : 0.5 * EaStyle.Sizes.fontPixelSize  // between title and content
    padding: 0
    topPadding: titleArea.height + spacing
    bottomPadding: title === '' ? 0 : EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize
    rightPadding: EaStyle.Sizes.fontPixelSize

    clip: true

    font.pixelSize: EaStyle.Sizes.fontPixelSize

    onCollapsedChanged: {
        collapsed === !collapsed
        if (collapsed || !EaGlobals.Vars.autoCollapseSideBarGroups) {
            return
        }
        // Collapse all other sidebar groups on this page
        for (const groupBox of parent.children) {
            if (groupBox !== control && typeof groupBox.collapsible !== 'undefined' && typeof groupBox.collapsed !== 'undefined') {
                if (groupBox.collapsible && !groupBox.collapsed) {
                    groupBox.collapsed = true
                }
            }
        }
    }

    // Group box title area

    label: Button {
        id: titleArea

        visible: title !== ''
        enabled: control.collapsible

        height: title === '' ? 0 : EaStyle.Sizes.tabBarHeight
        width: titleLayout.childrenRect.width + anchors.leftMargin + EaStyle.Sizes.fontPixelSize * 0.5

        anchors.left: control.left
        anchors.leftMargin: EaStyle.Sizes.fontPixelSize * 0.5
        topInset: 0
        bottomInset: 0

        checkable: false
        flat: true

        // Group box title layout
        contentItem: Row {
            id: titleLayout

            anchors.verticalCenter: parent.verticalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // Group box collapse icon
            Label {
                id: collapseIcon

                anchors.verticalCenter: parent.verticalCenter

                text: control.collapsible ? "play" : "circle"

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize * 0.7

                color: control.foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }

                transform: Rotation {
                    id: collapseIconRotation

                    origin.x: collapseIcon.width * 0.5
                    origin.y: collapseIcon.height * 0.5

                    angle: control.collapsed ? 0 : 90
                    Behavior on angle { EaAnimations.ThemeChange { duration: 500 } }
                }
            }

            // Group box title icon
            Label {
                visible: control.icon

                width: control.font.pixelSize
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter

                text: control.icon

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize

                color: control.foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }

            // Group box title text
            Label {
                id: titleTextlabel

                anchors.verticalCenter: parent.verticalCenter

                text: control.title

                font.family: EaStyle.Fonts.fontFamily
                font.pixelSize: control.font.pixelSize

                color: control.foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }

        //Mouse area to react on click events
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: undefined  // prevents changing the cursor
            onClicked: titleArea.clicked()
            //onPressed: (mouse) => mouse.accepted = false
        }

        // HoverHandler to react on hover events
        HoverHandler {
            id: mouseHoverHandler
            acceptedDevices: PointerDevice.AllDevices
            blocking: false
            cursorShape: Qt.PointingHandCursor
            onHoveredChanged: {
                if (hovered) {
                    //console.error(`${control} [TextInput.qml] hovered`)
                }
            }
        }

        // Folding-unfolding animation on title area clicked
        onClicked: control.collapsed = !control.collapsed
    }

    // Group box content area
    background: Rectangle {
        id: contentArea

        y: titleArea.height
        width: control.width
        height: control.height - control.topPadding + control.bottomPadding

        color: 'transparent'

        // Horisontal border at the bottom
        Rectangle {
            visible: !last

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6 + height // 6?

            width: control.width
            height: EaStyle.Sizes.borderThickness

            color: EaStyle.Colors.appBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }

    // Logic

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (mouseHoverHandler.hovered || !control.collapsed)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

}
