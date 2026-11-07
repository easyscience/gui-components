pragma Singleton

import QtQuick
import QtCore

import EasyApplication.Gui.Logic as EaLogic


QtObject {
    id: object

    // Python objects
    readonly property bool isTestMode: typeof pyIsTestMode !== "undefined" && pyIsTestMode !== null ?
                                          pyIsTestMode :
                                          false

    readonly property var projectConfig: typeof _projectConfig !== "undefined" && _projectConfig !== null ?
                                             _projectConfig :
                                             EaLogic.ProjectConfig.projectConfig()

    readonly property var translator: typeof pyTranslator !== "undefined" && pyTranslator !== null ?
                                          pyTranslator :
                                          new EaLogic.Translate.Translator()

    // Settings
    readonly property string settingsFile: typeof pySettingsPath !== "undefined" && pySettingsPath !== null ?
                                               Qt.resolvedUrl(pySettingsPath) :
                                               Qt.resolvedUrl('settings.ini')
    //onSettingsFileChanged: print("Persistent application settings path:", settingsFile)

    // Application parameters
    readonly property int appWindowFlags: Qt.Window | Qt.WindowFullscreenButtonHint // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false
    property bool showAppAboutDialog: false
    // Tooltips open at a level, "All", "Important" or "Off", after the pointer rests on a control for toolTipDelay ms.
    property string toolTipLevel: "Important"
    property int toolTipDelay: 1500
    // Whether any tooltip opens, for code that has not moved to toolTipAllowed yet; the app keeps it in step.
    property bool showToolTips: true
    property bool showUserGuides: false
    property bool showProjectDescriptionDialog: false
    property bool autoCollapseSideBarGroups: true

    // Updater
    property bool checkUpdateOnAppStart: isTestMode ? false : true
    property var updater

    // Logging
    property string loggingLevel: "Error"
    onLoggingLevelChanged: console.debug(`Logging level changed to ${loggingLevel}`)

    // Screenshots control
    property bool saveScreenshotsRunning: false

    // Tab buttons
    property var appearanceTab
    property var promptsTab

    // App bar
    property int appBarCurrentIndex: 0
    enum AppBarIndexEnum {
        HomePageIndex = 0,
        ProjectPageIndex = 1,
        SamplePageIndex = 2,
        ExperimentPageIndex = 3,
        AnalysisPageIndex = 4,
        SummaryPageIndex = 5
    }

    // Parameter name formats
    property int paramNameFormat: 0
    enum ParamNameFormats {
        ShortestWithIconsAndPrettyLabels = 0,
        //ReducedWithIconsAndPrettyLabels,
        //FullWithIconsAndPrettyLabels,
        //FullWithPrettyLabels,
        //FullWithLabels,
        //FullWithIndices,
        PlainShortWithLabels,
        PlainFullWithLabels }

    // Chart
    property string currentLib1d: "QtCharts"
    property bool useOpenGL: false

    // Persistent settings

    //property var settings1: Settings {
    //    location: settingsFile // Gives WASM error on run
    //    category: 'Preferences.Appearance'
    //    property alias currentLib1d: object.currentLib1d
    //}

    property var settings2: Settings {
        location: settingsFile // Gives WASM error on run
        category: 'Preferences.Develop'
        property alias loggingLevel: object.loggingLevel
    }

    property var settings3: Settings {
        location: settingsFile // Gives WASM error on run
        category: 'Pages.Analysis'
        property alias paramNameFormat: object.paramNameFormat
    }


    // The one place that decides whether a tooltip may open. Important leaves out a control whose label or icon
    // already says what it does, unless it is disabled: then its tooltip says why and how to enable it.
    function toolTipAllowed(selfExplanatory, disabled) {
        if (toolTipLevel === "All")
            return true
        if (toolTipLevel === "Important")
            return !selfExplanatory || disabled
        return false
    }
}
