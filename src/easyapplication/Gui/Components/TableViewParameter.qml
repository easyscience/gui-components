import QtQuick

import EasyApp.Gui.Logic as EaLogic
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements

EaElements.TextInput {
    id: control

    property bool flexibleWidth: false

    property var parameter: {'value': 0.0,
                             'idx': 0,
                             'error': 0.0,
                             'enabled': true,
                             'fittable': false,
                             'fit': false,
                             'category': '',
                             'name': 'default',
                             'prettyName': '',
                             'title': '',
                             'units': '',
                             'url': '',
                             'cifDict': ''}

    property var value: {
        if (typeof parameter.value === 'undefined') {
            return 0
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

    property int idx: parameter.idx ?? 0
    property bool fittable: parameter.fittable ?? false
    property bool fit: parameter.fit ?? false
    property string category: parameter.category ?? ''
    property string name: parameter.name ?? 'default'
    property string prettyName: parameter.prettyName ?? ''
    property string title: parameter.title ?? ''
    property string units: parameter.units ?? ''
    property string url: parameter.url ?? ''
    property string cifDict: parameter.cifDict ?? ''

    property alias fitCheckBox: fitCheckBox

    minored: !parameter.enabled ?? false

    height: parent.height

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: control.value
    font.bold: control.fit && enabled

    onAccepted: focus = false

    // Mouse area
    MouseArea {
        anchors.fill: parent
        cursorShape: undefined //Qt.PointingHandCursor
        acceptedButtons: Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            }
            mouse.accepted = false
        }
        onPressAndHold: (mouse) => {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                contextMenu.popup()
            }
            mouse.accepted = false
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

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        //cursorShape: undefined //Qt.PointingHandCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${control} [TableViewParameter.qml] hovered`)
            }
        }
    }
}
