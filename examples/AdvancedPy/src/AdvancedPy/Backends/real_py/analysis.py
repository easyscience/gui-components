# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import numpy as np
from PySide6.QtCore import QObject, Signal, Slot, Property, QPointF

from EasyApp.Logic.Logging import console


class Analysis(QObject):
    """
    Backend object that generates synthetic diffraction-like data
    and exposes it to QML as a list of QPointF values plus axis ranges.
    """

    # Signals
    dataSizeChanged = Signal()
    dataPointsChanged = Signal("QVariantList")   # Emitted with list<QPointF>
    axesRangesChanged = Signal()                 # Emitted when range dict updates

    def __init__(self):
        super().__init__()

        self._dataSize = 10000
        self._axesRanges = {
            "xmin": 0.0,
            "xmax": 180.0,
            "ymin": 0.0,
            "ymax": 100.0,
        }

    # ------------------------------------------------------------------
    # QML-accessible Properties
    # ------------------------------------------------------------------

    @Property(int, notify=dataSizeChanged)
    def dataSize(self):
        """Number of X/Y data points to generate."""
        return self._dataSize

    @dataSize.setter
    def dataSize(self, value):
        value = int(value)
        if self._dataSize == value:
            return
        self._dataSize = value
        self.dataSizeChanged.emit()

    @Property("QVariantMap", notify=axesRangesChanged)
    def axesRanges(self):
        """
        Axis ranges used by the graph:
        { "xmin": float, "xmax": float, "ymin": float, "ymax": float }
        Access in QML using: axisX.min: analysis.axesRanges["xmin"]
        """
        return self._axesRanges

    # ------------------------------------------------------------------
    # Public Slot Called from QML
    # ------------------------------------------------------------------

    @Slot()
    def generateData(self):
        """Generate new synthetic data and notify QML."""
        console.debug(f"* Generating {self.dataSize} data points...")
        x, y = self._generate_data(n_points=self.dataSize)
        console.debug("  Data generation completed.")

        console.debug(f"* Converting and sending {self.dataSize} data points to series...")
        self.dataPointsChanged.emit(self._ndarrays_to_qpoints(x, y))
        console.debug("  Data update signal emitted.")

        self._updateAxesRanges(x.min(), x.max(), y.min(), y.max())

    # ------------------------------------------------------------------
    # Internal Helpers
    # ------------------------------------------------------------------

    def _updateAxesRanges(self, xmin, xmax, ymin, ymax):
        """Store axis ranges and notify QML."""
        vmargin = 10.0
        self._axesRanges["xmin"] = float(xmin)
        self._axesRanges["xmax"] = float(xmax)
        self._axesRanges["ymin"] = max(0, float(ymin) - vmargin)
        self._axesRanges["ymax"] = float(ymax) + vmargin
        self.axesRangesChanged.emit()

    @staticmethod
    def _ndarrays_to_qpoints(x: np.ndarray, y: np.ndarray):
        """
        Convert NumPy X/Y arrays to list[QPointF].
        Uses memoryview to avoid Python float conversions inside numpy.
        """
        mvx = memoryview(x)
        mvy = memoryview(y)
        return [QPointF(xi, yi) for xi, yi in zip(mvx, mvy)]

    @staticmethod
    def _generate_data(
        n_points=2000,
        n_peaks=100,
        x_range=(0.0, 180.0),
        intensity_range=(0, 100),
        width_range=(0.05, 0.5),
        noise_level=1.0,
        background=20.0,
    ):
        """
        Generate synthetic diffraction-like pattern from sum of random Gaussians.
        Returns (x, y) NumPy arrays.
        """
        # Sample x grid
        x = np.linspace(*x_range, n_points)
        y = np.zeros_like(x)

        # Random peak positions, intensities, widths
        positions = np.random.uniform(*x_range, n_peaks)
        amplitudes = np.random.uniform(*intensity_range, n_peaks)
        widths = np.random.uniform(*width_range, n_peaks)

        # Gaussian peak contributions
        for pos, amp, width in zip(positions, amplitudes, widths):
            y += amp * np.exp(-0.5 * ((x - pos) / width) ** 2)

        # Noise
        y += np.random.normal(scale=noise_level, size=n_points)

        # Background
        y += background


        return x, y
