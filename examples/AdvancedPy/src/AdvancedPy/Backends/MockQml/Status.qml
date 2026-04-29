// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

pragma Singleton

import QtQuick

QtObject {

    readonly property string project: 'Undefined'
    readonly property string phasesCount: '1'
    readonly property string experimentsCount: '1'
    readonly property string calculator: 'CrysPy'
    readonly property string minimizer: 'Lmfit (leastsq)'
    readonly property string variables: '31 (3 free, 28 fixed)'

}
