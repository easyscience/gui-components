import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Logic as EaLogic

EaElements.Dialog {
    id: dialog

    property alias projectName: projectNameField.text
    property alias projectDescription: projectDescriptionField.text

    property string projectLocation: ""
    property string projectParentDirectory: ""
    property string defaultProjectParentDirectory: projectLocation

    property int inputFieldWidth: EaStyle.Sizes.fontPixelSize * 35

    title: qsTr("Create project")

    standardButtons: Dialog.Ok

    onAccepted: projectLocation = projectLocationField.text

    // Main layout

    Column {
        spacing: EaStyle.Sizes.fontPixelSize

        // Project name field

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Name")
            }

            EaElements.TextField {
                id: projectNameField

                implicitWidth: inputFieldWidth
                horizontalAlignment: TextInput.AlignLeft
                validator: RegularExpressionValidator { regularExpression: /^[a-zA-Z][a-zA-Z0-9_\-\.]{1,30}$/ }
                placeholderText: qsTr("Enter project name here")

                Keys.onReturnPressed: dialog.accept()
                Keys.onEnterPressed: dialog.accept()
            }
        }

        // Project description field

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Description")
            }

            EaElements.TextField {
                id: projectDescriptionField

                implicitWidth: inputFieldWidth
                horizontalAlignment: TextInput.AlignLeft
                placeholderText: qsTr("Enter project description here")

                Keys.onReturnPressed: dialog.accept()
                Keys.onEnterPressed: dialog.accept()
            }
        }

        // Project location field

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Location")
            }

            EaElements.TextField {
                id: projectLocationField

                implicitWidth: inputFieldWidth
                rightPadding: chooseParentDirectoryButton.width
                horizontalAlignment: TextInput.AlignLeft

                placeholderText: qsTr("Enter project location here")
                text: projectParentDirectory ?
                          EaLogic.Utils.urlToLocalFile(projectParentDirectory) + EaLogic.Utils.osPathSep() + projectName :
                          defaultProjectParentDirectory + EaLogic.Utils.osPathSep() + projectName

                Keys.onReturnPressed: dialog.accept()
                Keys.onEnterPressed: dialog.accept()

                EaElements.ToolButton {
                    id: chooseParentDirectoryButton

                    anchors.right: parent.right

                    fontIcon: "folder-open"
                    ToolTip.text: qsTr("Choose project parent directory")

                    showBackground: false

                    onClicked: projectParentDirDialog.open()
                }
            }
        }
    }

    // Choose project parent directory dialog

    FolderDialog {
        id: projectParentDirDialog

        title: qsTr("Choose project parent directory")
        selectedFolder: projectParentDirectory
        onAccepted: projectParentDirectory = selectedFolder
    }

    // Persistent settings

    Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Project.Location'
        property alias projectParentDirectory: dialog.projectParentDirectory
    }

}
