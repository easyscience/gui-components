# Shared check indicator colour contract

Status: proposed; native qualification belongs to the consuming release.

The first implementation is Elements/CheckBox.qml and its shared
Elements/CheckIndicator.qml. CheckIndicator reads its control's enabled, checked,
hovered and color properties; the original CheckBox declares color with the
live themeAccent default. MenuItem uses that same indicator but previously did
not declare color, leaving the enabled checked border branch undefined.

MenuItem now declares the same typed color property and themeAccent binding as
CheckBox. The original shared indicator keeps its existing branch order: disabled
foreground first, then checked control color, then hover or ordinary unchecked
border. Existing theme transitions, check state, symbol, visibility, geometry,
menu callbacks, text colour and native input remain unchanged. The property may
be overridden in the same way as the original CheckBox colour.

Only CheckBox and MenuItem instantiate this indicator in the current source.
Qualification uses their original checkable controls in light/dark themes and
enabled/disabled checked/unchecked states, including live theme changes. Native
warning absence is a runtime observation, not inferred from this source repair.
No consumer dependency pin or archive is invented by this change.
