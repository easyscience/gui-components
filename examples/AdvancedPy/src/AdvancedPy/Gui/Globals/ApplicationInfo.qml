// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

pragma Singleton

import QtQuick

QtObject {

    readonly property var about: {
        'name': 'AdvancedPy',
        'namePrefix': 'Advanced',
        'nameSuffix': 'Py',
        'namePrefixForLogo': 'advanced',
        'nameSuffixForLogo': 'py',
        'homePageUrl': 'https://github.com/EasyScience/EasyExample',
        'issuesUrl': 'https://github.com/EasyScience/EasyExample/issues',
        'licenseUrl': 'https://github.com/EasyScience/EasyExample/LICENCE.md',
        'dependenciesUrl': 'https://github.com/EasyScience/EasyExample/DEPENDENCIES.md',
        'version': '1.0.0',
        'icon': Qt.resolvedUrl('../Resources/Logos/App.svg'),
        'date': new Date().toISOString().slice(0,10),
        'developerYearsFrom': '2019',
        'developerYearsTo': '2024',
        'description': 'Example of a desktop application of advanced complexity with Python backend and EasyApplication-based GUI',
        'developerIcons': [
            {
                'url': 'https://ess.eu',
                'icon': Qt.resolvedUrl('../Resources/Logos/ESS.png'),
                'heightScale': 3.0
            }
        ]
    }

}

