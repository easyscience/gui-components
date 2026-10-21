pragma ComponentBehavior: Bound
import QtQuick

import EasyApplication.Gui.Logic as EaLogic
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements

// A parameter cell of a ListViewDelegate row: the value, bold when it is
// fitted, with a context menu (right click or press and hold) showing its
// name, value, units, uncertainty and fit toggle. The menu is made the first
// time it opens, as a list can hold many parameters.
EaElements.TextInput {
    id: control

    property bool flexibleWidth: false

    property var parameter: {
        'value': 0.0,
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
        'cifDict': ''
    }

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

    // The menu's column titles for the uncertainty and the fit toggle.
    property string errorTitle: 'error'
    property string fitTitle: 'vary'

    property EaElements.Menu contextMenu: null
    // The menu's fit toggle, once the menu is made.
    property EaElements.CheckBox fitCheckBox: null
    signal fitToggled(bool checked)

    function openContextMenu(parentItem) {
        if (contextMenu === null)
            contextMenu = contextMenuComponent.createObject(parentItem)
        contextMenu.popup()
    }

    minored: !parameter.enabled ?? false

    // The row's height; with no row yet, its own implicit height. Binding the height to
    // implicitHeight would make the text lay out in that height, which on macOS's
    // fractional line heights changed implicitHeight again: a binding loop.
    height: parent ? parent.height : undefined

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: control.value
    font.bold: control.fit && enabled

    onAccepted: focus = false

    // Mouse area
    MouseArea {
        id: menuArea
        anchors.fill: parent
        cursorShape: undefined //Qt.PointingHandCursor
        acceptedButtons: Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                control.openContextMenu(menuArea)
            }
            mouse.accepted = false
        }
        onPressAndHold: mouse => {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                control.openContextMenu(menuArea)
            }
            mouse.accepted = false
        }
        // Menu
        Component {
            id: contextMenuComponent

            EaElements.Menu {
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
                        visible: control.units !== ''
                        color: EaStyle.Colors.themeForegroundMinor
                        text: 'units'
                    }
                    EaElements.Label {
                        visible: (control.fittable || control.readOnly) && control.error !== ''
                        color: EaStyle.Colors.themeForegroundMinor
                        text: control.errorTitle
                    }
                    EaElements.Label {
                        visible: control.fittable && !control.readOnly
                        color: EaStyle.Colors.themeForegroundMinor
                        text: control.fitTitle
                    }

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
                        visible: control.units !== ''
                        text: control.units
                        color: EaStyle.Colors.themeForegroundMinor
                    }
                    EaElements.Label {
                        visible: (control.fittable || control.readOnly) && control.error !== ''
                        text: control.error
                    }
                    EaElements.CheckBox {
                        id: fitBox
                        visible: control.fittable && !control.readOnly
                        padding: 0
                        checked: control.fit
                        onToggled: control.fitToggled(checked)
                        Component.onCompleted: control.fitCheckBox = fitBox
                    }
                    // Content
                }
                // Layout
            }
        }
        // Menu
    }
    // Mouse area

    // HoverHandler to react on hover events
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
    }
}
