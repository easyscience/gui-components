import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

import EasyApp.Logic.Maintenance as EaMaintenance


T.ApplicationWindow {
    id: window

    property string appName: ''
    property string appVersion: ''
    property string appDate: ''

    property string webVersion: ''//updater.webVersion
    property string webDate: ''//updater.webDate

    visible: true
    flags: EaGlobals.Vars.appWindowFlags

    x: EaStyle.Sizes.appWindowX
    y: EaStyle.Sizes.appWindowY

    width: EaStyle.Sizes.appWindowWidth
    height: EaStyle.Sizes.appWindowHeight

    minimumWidth: EaStyle.Sizes.appWindowMinimumWidth
    minimumHeight: EaStyle.Sizes.appWindowMinimumHeight

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    // Updater

    EaMaintenance.Updater {
        id: updater

        onUpdateFound: updateFoundDialog.open()
        onUpdateNotFound: updateNotFoundDialog.open()
        onUpdateFailed: updateFailedDialog.open()

        Component.onCompleted: EaGlobals.Vars.updater = this
    }

    // Check update on app start (if needed)

    Timer {
        interval: 2000
        repeat: false
        running: EaGlobals.Vars.checkUpdateOnAppStart
        onTriggered: {
            updater.silentCheck = true
            updater.checkUpdate()
        }
    }

    // Updater dialogs

    EaElements.Dialog {
        id: updateFoundDialog

        title: qsTr('Update Available')

        Column {
            spacing: EaStyle.Sizes.fontPixelSize

            EaElements.Label {
                textFormat: Text.RichText
                text: qsTr("Current version: %1 (%2)<br>
                            Available version: %3 (%4)"
                           .arg(appVersion).arg(appDate)
                           .arg(webVersion).arg(webDate))
            }

            Column {
                visible: updater.releaseNotes

                EaElements.Label {
                    text: qsTr("Release notes:")
                }

                ScrollView {
                    width: EaStyle.Sizes.fontPixelSize * 40
                    height: EaStyle.Sizes.fontPixelSize * 25
                    clip: true

                    EaElements.TextArea {
                        wrapMode: TextEdit.Wrap
                        readOnly: true
                        backgroundOpacity: 0.5
                        textFormat: Text.MarkdownText
                        text: updater.releaseNotes
                    }
                }
            }
        }

        footer: EaElements.DialogButtonBox {
            EaElements.Button {
                text: qsTr("Not Now")
                onClicked: updateFoundDialog.close()
            }

            EaElements.Button {
                text: qsTr("Update")
                onClicked: updater.installUpdate()
            }
        }
    }

    EaElements.Dialog {
        id: updateNotFoundDialog

        title: qsTr('No Updates')

        standardButtons: Dialog.Ok

        EaElements.Label {
            textFormat: Text.RichText
            text: qsTr("You are up to date.<br><br>
                        %1 version %2 (%3)<br>
                        is currently the newest version available."
                       .arg(appName).arg(appVersion).arg(appDate))
        }
    }

    EaElements.Dialog {
        id: updateFailedDialog

        title: qsTr('Update Error')

        standardButtons: Dialog.Ok

        EaElements.Label {
            textFormat: Text.RichText
            text: qsTr('There was an error checking for updates.
                        <br>
                        Please try again later.')
        }
    }

    // Quit animation

    PropertyAnimation {
        id: quitAnimo

        target: window

        property: 'opacity'
        to: 0

        duration: 150
        easing.type: Easing.InCubic

        alwaysRunToEnd: true

        onFinished: Qt.quit()
    }

    function quit() {
        quitAnimo.start()
    }
}
