# Shared remote pointer pulse

Status: implemented in source; consuming native/render qualification is pending.

FIRST is Elements/RemotePointer.qml, including its public move/click/show/hide
methods, coral color, placement center, sizes, opacities and duration properties.
The previous click jumped width/height/radius and x/y to its maximum size, then
changed that geometry every GUI-thread frame while shrinking. pressDuration was
published but unused. All consumers must use this original pointer rather than
an application-local replacement.

The original rectangle keeps its minimum geometry and center transform origin.
A click grows its rendered scale/opacity during pressDuration and relaxes during
clickRelaxation. The groups contain only Qt Quick Animator types so the threaded
render loop can animate their scene-graph state. Original movement uses X/Y
Animators; show/hide retain opacity and initial center placement. Public calls
stop conflicting animation owners before starting the next one; hiding cannot
be undone by a late click relaxation, and a new move/show returns to minimum
scale. No input handler, new visible control, color/style or alternative pointer
is introduced. Geometry remains meaningful while the rendered circle grows.

Qt documents that Animator property values synchronize when animation finishes,
not every rendered frame. This pointer's public methods retain position inputs;
callers must not use its transient QML geometry as the rendered-frame position.
Animators offer no threading benefit under a basic render loop and cannot fix
blocking GUI work generally. No measured latency gain or all-jank remedy is
claimed. Qualification belongs to the consuming build and covers the original
pulse/move/show/hide paths, overlapping calls, both render-loop behavior and
existing target/input ownership.

Primary API: https://doc.qt.io/qt-6/qml-qtquick-animator.html and
https://doc.qt.io/qt-6/qml-qtquick-scaleanimator.html .
