// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick
import QtGraphs

import Gui.Globals as Globals


QtObject {

    property int dataSize: 50
    property var axesRanges: {
        "xmin": 0.0,
        "xmax": 180.0,
        "ymin": 0.0,
        "ymax": 100.0,
    }

    signal dataPointsChanged(var points)

    function generateData() {
        console.debug(`* Generating ${dataSize} data points...`)
        const xmin = axesRanges.xmin
        const xmax = axesRanges.xmax
        const ymin = axesRanges.ymin
        const ymax = axesRanges.ymax

        const stepSize = (xmax - xmin) / (dataSize - 1)

        let dataPoints = []
        for (let i = 0; i < dataSize + 1; i++) {
            const x = i * stepSize
            const y = ymin + Math.random() * (ymax - ymin)
            dataPoints.push(Qt.point(x, y))
        }
        console.debug("  Data generation completed.")

        console.debug(`* Sending ${dataSize} data points to series...`)
        dataPointsChanged(dataPoints)
        console.debug("  Data update signal emitted.")
    }

}
