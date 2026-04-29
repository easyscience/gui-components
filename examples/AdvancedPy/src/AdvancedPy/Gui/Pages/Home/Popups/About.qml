// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.AboutDialog {

    visible: EaGlobals.Vars.showAppAboutDialog
    onClosed: EaGlobals.Vars.showAppAboutDialog = false

    appIconPath: Globals.ApplicationInfo.about.icon
    appUrl: Globals.ApplicationInfo.about.homePageUrl

    appPrefixName: Globals.ApplicationInfo.about.namePrefixForLogo
    appSuffixName: Globals.ApplicationInfo.about.nameSuffixForLogo
    appVersion: Globals.ApplicationInfo.about.version
    appDate: Globals.ApplicationInfo.about.date

    eulaUrl: Globals.ApplicationInfo.about.licenseUrl
    oslUrl: Globals.ApplicationInfo.about.dependenciesUrl

    description: Globals.ApplicationInfo.about.description
    developerIcons: Globals.ApplicationInfo.about.developerIcons
    developerYearsFrom: Globals.ApplicationInfo.about.developerYearsFrom
    developerYearsTo: Globals.ApplicationInfo.about.developerYearsTo

}
