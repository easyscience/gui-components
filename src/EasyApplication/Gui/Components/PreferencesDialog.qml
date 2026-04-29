import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
//import QtQuick.XmlListModel 2.15
import QtCore

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


EaElements.Dialog {
    id: dialog

    contentWidth: bar.implicitWidth
    contentHeight: bar.implicitHeight +
                   implicitHeaderHeight +
                   topPadding +
                   bottomPadding +
                   EaStyle.Sizes.fontPixelSize * 9

    visible: EaGlobals.Vars.showAppPreferencesDialog
    onClosed: EaGlobals.Vars.showAppPreferencesDialog = false

    title: qsTr("Preferences")

    standardButtons: Dialog.Ok

    Component.onCompleted: setPreferencesOkButton()

    // TabBar

    EaElements.TabBar {
        id: bar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        background: Rectangle {
            z: 2
            anchors.fill: parent
            color: "transparent"
            border.color: EaStyle.Colors.appBarBorder
        }

        EaElements.AppBarTabButton {
            fontIcon: "users"
            text: qsTr("Prompts")
            ToolTip.text: qsTr("")

            Component.onCompleted: EaGlobals.Vars.promptsTab = this
        }

        EaElements.AppBarTabButton {
            fontIcon: "cloud-download-alt"
            text: qsTr("Updates")
            ToolTip.text: qsTr("")
        }

        EaElements.AppBarTabButton {
            fontIcon: "paint-brush"
            text: qsTr("Appearance")
            ToolTip.text: qsTr("")

            Component.onCompleted: EaGlobals.Vars.appearanceTab = this
        }

        EaElements.AppBarTabButton {
            fontIcon: "flask"
            text: qsTr("Experimental")
            ToolTip.text: qsTr("")
        }

        EaElements.AppBarTabButton {
            fontIcon: "laptop-code"
            text: qsTr("Develop")
            ToolTip.text: qsTr("")
        }
    }

    // Main area

    SwipeView {
        id: view

        anchors.top: bar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: EaStyle.Sizes.fontPixelSize * 0.75
        leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
        bottomPadding: EaStyle.Sizes.fontPixelSize * 3

        currentIndex: bar.currentIndex

        clip: true

        // Prompts tab content

        Grid {
            columns: 2
            topPadding: EaStyle.Sizes.fontPixelSize * 0.5
            rowSpacing: EaStyle.Sizes.fontPixelSize * 1.5
            columnSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
               text: qsTr("Enable tool tips") + ":"
            }

            EaElements.CheckBox {
                id: toolTipsCheckBox
                checked: EaGlobals.Vars.showToolTips
                onCheckedChanged: EaGlobals.Vars.showToolTips = checked
            }

            EaElements.Label {
                enabled: false
                text: qsTr("Enable user guides") + ":"
            }

            EaElements.CheckBox {
                id: userGuidesCheckBox
                enabled: false
                checked: EaGlobals.Vars.showUserGuides
                onCheckedChanged: EaGlobals.Vars.showUserGuides = checked
            }

        }

        // Updates tab content

        Column {
            topPadding: EaStyle.Sizes.fontPixelSize * 0.5
            spacing: EaStyle.Sizes.fontPixelSize * 1.5

            Row {
                id: checkOnAppStartRow
                spacing: EaStyle.Sizes.fontPixelSize

                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Check on application start") + ":"
                }

                EaElements.CheckBox {
                    id: updatesCheckBox
                    padding: 0
                    checked: EaGlobals.Vars.checkUpdateOnAppStart
                    onCheckedChanged: EaGlobals.Vars.checkUpdateOnAppStart = checked
                }
            }

            EaElements.SideBarButton {
                width: checkOnAppStartRow.width
                highlighted: true
                text: qsTr("Check now")
                onClicked: {
                    EaGlobals.Vars.updater.silentCheck = false
                    EaGlobals.Vars.updater.checkUpdate()
                }
            }
        }

        // Appearance tab content

        Grid {
            columns: 3
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
                text: qsTr("Theme") + ":"
            }

            EaElements.ComboBox {
                model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                onActivated: {
                    if (currentIndex === 0)
                        EaStyle.Colors.theme = EaStyle.Colors.LightTheme
                    else if (currentIndex === 1)
                        EaStyle.Colors.theme = EaStyle.Colors.DarkTheme
                    else if (currentIndex === 2)
                        EaStyle.Colors.theme = EaStyle.Colors.SystemTheme
                }
                Component.onCompleted: {
                    if (EaStyle.Colors.theme === EaStyle.Colors.LightTheme)
                        currentIndex = 0
                    else if (EaStyle.Colors.theme === EaStyle.Colors.DarkTheme)
                        currentIndex = 1
                    else if (EaStyle.Colors.theme === EaStyle.Colors.SystemTheme)
                        currentIndex = 2
                }
            }

            EaElements.Label { text: ' ' }

            EaElements.Label {
                enabled: false
                text: qsTr("1D plotting") + ":"
            }

            EaElements.ComboBox {
                id: currentLib1dSelector
                enabled: false
                model: ['Plotly', 'QtCharts']
                //onActivated: EaGlobals.Vars.currentLib1d = currentValue
                onActivated: EaGlobals.Vars.currentLib1d === currentValue ?
                                 restartRequiredLabel.visible = false :
                                 restartRequiredLabel.visible = true
                currentIndex: model.indexOf(EaGlobals.Vars.currentLib1d)
                //Component.onCompleted: currentIndex = model.indexOf(EaGlobals.Vars.currentLib1d)
            }

            EaElements.Label { text: ' ' }

            /*
            EaElements.CheckBox {
                id: useOpenGL1dCheckBox
                text: {
                    if (EaGlobals.Vars.currentLib1d === 'QtCharts') {
                        return qsTr("Use OpenGL")
                    } else if (EaGlobals.Vars.currentLib1d === 'Plotly') {
                        return qsTr("Use WebGL")
                    }
                }
                checked: EaGlobals.Vars.useOpenGL
                onCheckedChanged: EaGlobals.Vars.useOpenGL = checked
                //Component.onCompleted: checked = EaGlobals.Vars.useOpenGL
            }
            */

            /*
            EaElements.Label {
                visible: ExGlobals.Constants.appName === 'easydiffraction'
                text: qsTr("Structure plotting") + ":"
            }

            EaElements.ComboBox {
                model: ExGlobals.Constants.proxy.plotting3d.plotting3dLibs
                onActivated: ExGlobals.Constants.proxy.plotting3d.current3dPlottingLib = currentValue
                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.plotting3d.current3dPlottingLib)
                }
            }
            */

            EaElements.Label {
                topPadding: autoCollapseCheckBox.topPadding
                text: qsTr("Auto collapse") + ":"
            }

            EaElements.CheckBox {
                id: autoCollapseCheckBox
                topPadding: 0.5 * EaStyle.Sizes.fontPixelSize
                leftPadding: -3
                checked: EaGlobals.Vars.autoCollapseSideBarGroups
                onCheckedChanged: EaGlobals.Vars.autoCollapseSideBarGroups = checked
                ToolTip.text: qsTr("Auto collapse for side bar groups")
            }

            EaElements.Label { text: ' ' }

        }

        // Experimental tab content

        Grid {
            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            // Zoom
            EaElements.Label {
                text: qsTr("Zoom") + ":"
            }

            EaElements.ComboBox {
                model: ["100%", "110%", "120%", "130%", "140%", "150%"]
                onCurrentTextChanged: {
                    if (parseInt(currentText) === EaStyle.Sizes.defaultScale) {
                        return
                    }
                    EaStyle.Sizes.defaultScale = parseInt(currentText)
                }
            }
            // Zoom

            // Language
            EaElements.Label {
                text: qsTr("Language") + ":"
            }

            EaElements.ComboBox {
                valueRole: "code"
                textRole: "name"

                model: EaGlobals.Vars.translator.languages

                onActivated: EaGlobals.Vars.translator.selectLanguage(currentIndex)
                Component.onCompleted: currentIndex = EaGlobals.Vars.translator.defaultLanguageIndex()
            }
            // Language

        }

        // Develop tab content

        Grid {
            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
                enabled: false
                text: qsTr("Logging to") + ":"
            }

            EaElements.ComboBox {
                enabled: false
                model: ["Disabled", "Terminal", "File"]
                currentIndex: 1
            }

            EaElements.Label {
                text: qsTr("Logging level") + ":"
            }

            EaElements.ComboBox {
                id: loggingLevelSelector
                model: ["Debug", "Info", "Error", "Disabled"]
                currentIndex: model.indexOf(EaGlobals.Vars.loggingLevel)
                onActivated: EaGlobals.Vars.loggingLevel = currentValue
            }
        }

    }

    // Info label

    Label {
        id: restartRequiredLabel

        visible: false
        anchors.top: view.bottom
        text: qsTr('Application restart is required for changes to take effect.')
        color: EaStyle.Colors.themeForegroundHighlight
    }

    // Persistent settings

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Prompts'
        property alias enableToolTips: toolTipsCheckBox.checked
        property alias enableUserGuides: userGuidesCheckBox.checked
    }

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Updates'
        property alias checkUpdateOnAppStart: updatesCheckBox.checked
    }

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Appearance'
        property alias currentLib1d: currentLib1dSelector.currentValue
    }

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Appearance'
        property alias autoCollapseSideBarGroups: autoCollapseCheckBox.checked
    }

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Develop'
        property alias loggingLevel: loggingLevelSelector.currentValue
    }

    // Logic

    function setPreferencesOkButton() {
        const buttons = dialog.footer.contentModel.children
        for (let i in buttons) {
            const button = buttons[i]
            if (button.text === 'OK') {
                return
            }
        }
    }
}
