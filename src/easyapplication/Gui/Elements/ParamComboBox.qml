import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements


EaElements.ComboBox {
    id: control

    property var parameter: {'value': 0.0,
                             'permittedValues': [],
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
            return 0
        } else if (typeof parameter.value === 'number') {
            return parseFloat(parameter.value.toFixed(4))
        } else {
            return parameter.value
        }
    }
    property var permittedValues: parameter.permittedValues ?? []
    property var error: {
        if (typeof parameter.error === 'undefined') {
            return 0
        } else {
            return parseFloat(parameter.error.toFixed(4))
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

    enabled: model.length

    topInset: control.shortPrettyName === '' ? 0 : EaStyle.Sizes.fontPixelSize * 1.5
    topPadding: topInset + padding

    width: (EaStyle.Sizes.sideBarContentWidth -
            (parent.children.length - 1) * EaStyle.Sizes.fontPixelSize * 0.5) /
           parent.children.length

    model: permittedValues

    currentIndex: indexOfValue(control.value)

    onAccepted: focus = false

    // Title
    EaElements.Label {
        anchors.left: control.left
        anchors.leftMargin: control.contentItemLabel.leftPadding

        color: EaStyle.Colors.themeForegroundMinor

        font.bold: false
        text: control.shortPrettyName
    }
    // Title

    // Mouse area
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
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
                    visible: control.fittable && control.error !== 0
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
                    visible: control.fittable && control.error !== 0
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
