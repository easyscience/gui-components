import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Logic as EaLogic
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements


EaElements.TextField {
    id: control

    property var parameter: {'value': 0.0,
                             'error': 0.0,
                             'enabled': true,
                             'fittable': false,
                             'fit': false,
                             'category': '',
                             'name': 'default',
                             'prettyName': '',
                             'shortPrettyName': '',
                             'units': '',
                             'url': '',
                             'cifDict': ''}

    property var value: {
        if (typeof parameter.value === 'undefined') {
            return ''
        } else if (typeof parameter.value === 'number') {
            return EaLogic.Utils.toErrSinglePrecision(parameter.value, parameter.error)
        } else {
            return parameter.value
        }
    }
    property var error: {
        if (typeof parameter.error === 'undefined') {
            return ''
        } else if (typeof parameter.value === 'number') {
            return EaLogic.Utils.toSinglePrecision(parameter.error)
        } else {
            return parameter.error
        }
    }

    property bool fittable: parameter.fittable ?? false
    property bool fit: parameter.fit ?? false
    property string category: parameter.category ?? ''
    property string name: parameter.name ?? 'default'
    property string prettyName: parameter.prettyName ?? ''
    property string shortPrettyName: parameter.shortPrettyName ?? ''
    property string units: parameter.units ?? ''
    property string url: parameter.url ?? ''
    property string cifDict: parameter.cifDict ?? ''

    property alias fitCheckBox: fitCheckBox

    readOnly: !parameter.enabled ?? false

    rightPadding: unitsPlaceholder.width
    topInset: control.shortPrettyName === '' ? 0 : EaStyle.Sizes.fontPixelSize * 1.5
    topPadding: topInset + padding

    width: (EaStyle.Sizes.sideBarContentWidth -
            (parent.children.length - 1) * EaStyle.Sizes.fontPixelSize * 0.5) /
           parent.children.length

    text: control.value
    font.bold: control.fit && enabled

    onAccepted: focus = false

    // Title
    EaElements.Label {
        anchors.right: parent.right
        rightPadding: unitsPlaceholder.rightPadding

        color: EaStyle.Colors.themeForegroundMinor

        font.bold: false
        text: control.shortPrettyName
    }
    // Title

    // Units
    PlaceholderText {
        id: unitsPlaceholder

        x: control.width - width
        topPadding: control.topPadding
        leftPadding: text !== '' ? EaStyle.Sizes.fontPixelSize * 0.5 : 0
        rightPadding: EaStyle.Sizes.fontPixelSize * 0.75

        font.family: control.font.family
        font.pixelSize: control.font.pixelSize
        font.bold: false
        color: control.placeholderTextColor

        text: control.units
        textFormat: Text.RichText
    }
    // Units

    //Mouse area to react on click events
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        cursorShape: undefined  // prevents changing the cursor
        hoverEnabled: false
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            }
        }
        onPressAndHold: (mouse) => {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                contextMenu.popup()
            }
        }
        // Menu
        EaElements.Menu {
            id: contextMenu

            width: layout.implicitWidth

            // Layout
            Grid {
                id: layout

                leftPadding: 1.25 * EaStyle.Sizes.fontPixelSize
                rightPadding: 1.25 * EaStyle.Sizes.fontPixelSize
                topPadding: 0.5 * EaStyle.Sizes.fontPixelSize
                bottomPadding: 0.75 * EaStyle.Sizes.fontPixelSize
                rowSpacing: 0.75 * EaStyle.Sizes.fontPixelSize
                columnSpacing: 1.5 * EaStyle.Sizes.fontPixelSize

                rows: 2

                // Header
                EaElements.Label {
                    color: EaStyle.Colors.themeForegroundMinor
                    text: control.cifDict ? 'cif name' : 'cif-like name'
                }
                EaElements.Label {
                    color: EaStyle.Colors.themeForegroundMinor
                    text: 'value'
                }
                EaElements.Label {
                    visible: control.fittable && control.error !== ''
                    color: EaStyle.Colors.themeForegroundMinor
                    text: 'error'
                }
                EaElements.Label {
                    visible: control.fittable && !control.readOnly
                    color: EaStyle.Colors.themeForegroundMinor
                    text: 'vary'
                }
                // Headert

                // Content
                EaElements.Button {
                    text: `${control.category}.${control.name}`
                    checked: true
                    onClicked: Qt.openUrlExternally(control.url)
                }
                EaElements.Label {
                    text: control.value
                    font.bold: control.fit
                }
                EaElements.Label {
                    visible: control.fittable && control.error !== ''
                    text: control.error
                }
                EaElements.CheckBox {
                    id: fitCheckBox
                    visible: control.fittable && !control.readOnly
                    padding: 0
                    checked: control.fit
                }
                // Content
            }
            // Layout
        }
        // Menu
    }
    // Mouse area
}
