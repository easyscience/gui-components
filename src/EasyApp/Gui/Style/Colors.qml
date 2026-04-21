pragma Singleton

import QtQuick
import QtQuick.Controls.Material
import QtCore

import EasyApp.Gui.Globals as EaGlobals


QtObject {
    id: object

    // Theme
    enum Themes { LightTheme = 0, DarkTheme, SystemTheme }
    property int theme: Colors.Themes.SystemTheme
    onThemeChanged: console.debug(`App color theme: ${theme} (0 - light, 1 - dark, 2 - system)`)

    property int systemColorScheme: -1
    onSystemColorSchemeChanged: console.debug(`System color scheme: ${systemColorScheme} (0 - unknown, 1 - light, 2 - dark)`)

    property bool isDarkPalette: {
        if (theme === Colors.Themes.DarkTheme) {
            return true
        } else if (theme === Colors.Themes.LightTheme) {
            return false
        } else if (theme === Colors.Themes.SystemTheme) {
            if (systemColorScheme === Qt.ColorScheme.Dark) {
                return true
            } else if (systemColorScheme === Qt.ColorScheme.Light) {
                return false
            } else if (systemColorScheme === Qt.ColorScheme.Unknown) {
                return false
            } else {
                return false
            }
        } else {
            return false
        }
    }
    onIsDarkPaletteChanged: console.debug(`Is dark palette: ${isDarkPalette}`)

    property color themeAccent: isDarkPalette ? "#4ec1ef": "#00a3e3"
    property color themeAccentMinor: isDarkPalette ? "#4d9dbd" : "#8ad6ed"
    property color themePrimary: isDarkPalette ? "#111" : "#bbb"

    property color themeBackground: isDarkPalette ? "#303030" : "#e9e9e9"
    property color themeBackgroundDisabled: isDarkPalette ? "#333" : "#e9e9e9"
    property color themeBackgroundHovered1: isDarkPalette ? "#353535" : "#fefefe"
    property color themeBackgroundHovered2: isDarkPalette ? "#3a3a3a" : "#f7f7f7"

    property color themeForeground: isDarkPalette ? "#eee" : "#333"
    property color themeForegroundMinor: isDarkPalette ? "#888" : "#aaa"
    property color themeForegroundDisabled: isDarkPalette ? "#555": "#bbb" // control.Material.hintTextColor
    property color themeForegroundHovered: themeAccent
    property color themeForegroundHighlight: isDarkPalette ? '#FFAB91' : '#FF5722'

    property color themeRowHovered: isDarkPalette ? "#394247" : "#E6F5FC"
    property color themeRowHighlight: isDarkPalette ? "#374952" : "#DCF0FA"
    property color themeRowHighlightHovered: isDarkPalette ? "#3D5E6E" : "#C9E6F5"


    // Application window
    property color appBorder: isDarkPalette ? "#292929" : "#ddd"

    // Application bar (on top of the application window)
    property color appBarBackground: themeBackground
    property color appBarForeground: isDarkPalette ? "#eee" : "#222"
    property color appBarBorder: isDarkPalette ? "#2e2e2e" : "#d6d6d6"

    property color appBarButtonBackground: "transparent"
    property color appBarButtonBackgroundDisabled: "transparent"
    property color appBarButtonBackgroundHovered: isDarkPalette ? "#20666666" : "#15666666" // temporary disable because of problems with RemoteController if parent: Overlay.overlay !?
    property color appBarButtonBackgroundPressed: isDarkPalette ? "#50666666" : "#25666666"
    property color appBarButtonForeground: isDarkPalette ? "#ccc" : "#444"

    property color appBarComboBoxBackground: isDarkPalette ? "#10666666" : "#70ffffff"
    property color appBarComboBoxBackgroundHovered: isDarkPalette ? "#50666666" : "#bbffffff"
    property color appBarComboBoxBackgroundPressed: isDarkPalette ? "#90666666" : "#ffffffff"
    property color appBarComboBoxBorder: isDarkPalette ? Qt.darker(appBarBackground, 1.1) : Qt.darker(appBarBackground, 1.05)

    // Content
    property color contentBackground: isDarkPalette ? "#3a3a3a" : "#f4f4f4"
    property color mainContentBackground: isDarkPalette ? "#444" : "#fff"
    property color mainContentBackgroundHalfTransparent: isDarkPalette ? "#E6444444" : "#E6ffffff"

    // SideBar
    property color sideBarButtonBackground: appBarBackground
    property color sideBarButtonBackgroundHovered: isDarkPalette ? "#50666666" : "#e0e0e0"
    property color sideBarButtonBackgroundPressed: isDarkPalette ? "#50666666" : "#ccc"
    property color sideBarButtonForeground: isDarkPalette ? "#ccc" : "#444"

    // Status bar
    property color statusBarBackground: appBarBackground
    property color statusBarTextForeground: isDarkPalette ? "#888": "#777"
    property color statusBarIconForeground: isDarkPalette ? "#666": "#999"

    // Dialogs
    property color dialogBackground: contentBackground//themeBackground
    property color dialogOutsideBackground: isDarkPalette ? "#80000000" : "#80ffffff"
    property color dialogForeground: themeForeground

    // TextView
    property color textViewForeground: themeForeground
    property color textViewForegroundDisabled: themeForegroundDisabled
    property color textViewBackground: themeBackgroundHovered1
    property color textViewBackgroundDisabled: themeBackgroundHovered2

    // Text
    property color link: themeAccent
    property color linkHovered: isDarkPalette ? Qt.darker(themeAccent, 1.1) : Qt.lighter(themeAccent, 1.15)

    // Charts
    //property var chartForegrounds: ['#00a3e3', '#ff7f50', '#6b8e23']
    property var chartForegrounds: isDarkPalette ? ['#EF9A9A', '#B0BEC5', '#C5E1A5'] : ['#F44336', '#607D8B', '#8BC34A']  // red (M), blue grey (M), light green (M)
    property var chartForegroundsExtra: isDarkPalette ? ['#FFCC80', '#A5D6A7', '#81D4FA', '#BCAAA4'] : ['#FF9800', '#4CAF50', '#03A9F4', '#795548']  // orange (M), green (M), light blue (M), brown
    property var models: isDarkPalette ? ['#FFCC80', '#80CBC4', '#F48FB1'] : ['#FF9800', '#009688', '#E91E63']  // orange (M), teal (M), pink (M)
    property color chartForeground: themeForeground
    property color chartBackground: mainContentBackground
    property color chartPlotAreaBackground: mainContentBackground
    property color chartAxis: isDarkPalette ? "#2a2a2a" : "#ddd"
    property color chartGridLine: isDarkPalette ? "#3a3a3a" : "#eee"
    property color chartMinorGridLine: themeBackground
    property color chartLabels: chartForeground
    property color chartLine: "coral"

    // Table
    property color tableHighlight: isDarkPalette ? "#204ec1ef": "#2000a3e3"

    // ToolTip
    property color toolTipBackground: mainContentBackground
    property color toolTipBorder: appBarBorder

    // Colors
    property color blue: isDarkPalette ? '#81D4FA' : '#39abdf'
    property color red: isDarkPalette ? '#FFAB91' : '#FF5722'
    property color green: isDarkPalette ? '#C5E1A5' : '#7aaa42'
    property color grey: isDarkPalette ? "#222": "#666"
    property color orange: isDarkPalette ? '#FFCC80' : '#FF9800'

    // Persistent settings

    property var settings: Settings {
        location: EaGlobals.Vars.settingsFile // Gives WASM error on run
        category: 'Preferences.Appearance'
        property alias theme: object.theme
    }

}
