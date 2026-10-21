# List row background and nested control input

Status: proposed; native qualification belongs to the consuming release.

The first implementation is Components/ListViewDelegate.qml, its editor
FocusScope and ListView.endEditing(). TableViewDelegate and ListViewHeader
already use MouseArea for item-level background input. A row may contain native
TextField, Button and ComboBox controls. Clicking such a control must leave its
native focus, selection, press/release and click behavior intact. Only an actual
row-background click ends the current edit and updates row selection.

A default ancestor TapHandler takes a passive grab and can react to a click
already handled by another item. Moving it behind the cells still permits
PointerHandler delivery. It cannot distinguish the intended row background by
stacking order alone. The row now puts a MouseArea inside its existing background
rectangle, before the editor FocusScope. Accepted foreground control presses do
not reach that background item; unhandled labels and padding still do. The
background remains input-capable when the visual hover tint has zero opacity.
The MouseArea is not an overlay and does not propagate accepted composed clicks.

Keep the existing currentIndex, endEditing and modifier-aware selection order.
Retain native Flickable stealing/cancellation for scrolling; do not block it or
force focus onto an editor. Editing-driven selection, keyboard handling, hover,
colors, column layout and all cell callbacks remain unchanged. Child controls
may still intentionally end their own editing; the row background must not add
an unrelated focus change to their accepted click.

Qualification must exercise a real nested text field (focus, selection and
manual draft), native button and combo click, noninteractive label/padding click
with selection modifiers, and drag scrolling. Check both prior active edits and
row reuse/removal. Use existing native consumer tests; dummy arithmetic tests do
not qualify pointer delivery. Source reasoning identifies this contract defect,
not the actor behind any particular consuming application's focus loss.


## Shared selection paint and current-row geometry

FIRST is Components/ListView.qml, ListViewDelegate's original ItemSelectionModel
and background MouseArea/editor FocusScope, and Elements/TabBar's accent underline.
Ordinary shared consumers, with or without ListViewHeader, get alternating rows
and the unchanged ordinary hover/edit paint. Selection does not add a persistent
blue full-row fill or a separate selected-hover fill. A single selected row uses one moving two-pixel accent marker,
with the tab underline's 250ms motion. Multiple selected rows keep individual
accent bars and the original unselected anchor marker. SelectionActive still dims
all markers; selected/inSelection remain truthful APIs.

The optional currentRow input supplies a backend presentation row without writing
currentIndex, selection, focus or content position. The shared marker takes y and
height from the actual itemAtIndex delegate in contentItem coordinates, not index
multiplied by a guessed row height. View/delegate layout and virtualization signals
refresh that item; destroyed items clear their typed Item reference. It stays below
the original z:3 overlay header and inside the original clipped viewport. Initial
appearance/removal snaps in place; movement between realized targets is smoothed.

Ctrl/Shift selection, clear/anchor bookkeeping, model and header APIs, editing,
accepted child controls, focus release and Flickable stealing remain the original
implementation. No marker handles input. Consumers must not add another bar/fill.
Edi's existing current-row adapter must use this same facility and remove its local
parallel Rectangle/color overrides; its null-safe model/header replacement stays.
Native qualification must check ordinary unmodified shared delegates, headerless
scrolling/variable geometry, multi-selection, clear/anchor, nested editor/button/
combo input and both themes. Source proposal alone is not native/render evidence.


## Synchronous marker refresh during model replacement

FIRST is the shared ListView.refreshMarker implementation and Edi's existing
null-safe/typed-header replacement of that component. Geometry, row and content
callbacks refresh the same actual delegate marker synchronously. They must not
read the native ListView.model property: Qt 6.11.1 setModel temporarily clears its
internal model before resetting content position, while its owning-model flag
still permits the getter to dereference that cleared pointer. Ordinary QObject
validity does not prove the native model getter is safe inside those callbacks.

The marker records modelChanged with its own revision and compares that revision
after the existing markerMoves publication. It also rechecks the live view, the
requested marker row and the actual realized item, including a null target, before
publishing markerItem. Replacing a model during a synchronous callback therefore
retires the earlier snapshot without reading ListView.model. Count and realized
item lookup remain the original geometry inputs; no timer, platform switch,
selection/focus/scroll write or persistent row fill is added. Edi's existing
replacement carries the same correction and retains its model/header protections.

The owner Mac crash reports dated 2026-10-21 17:02:10 and 17:02:26 identify a model
getter fault during setModel/content-position callbacks in initial QML creation.
Their exact QML caller is inferred from the source and native stack, not a QML
source-line backtrace. The official Qt source documents the native transient:
https://github.com/qt/qtdeclarative/blob/v6.11.1/src/quick/items/qquickitemview.cpp
(model getter/setter, count and itemAtIndex). Source diagnosis and this correction
do not qualify changed-source startup, rendering or native tests. Qualification
must include synchronous startup/model replacement with changed content position,
reentrant replacement from markerMoves notification, null/replaced/deleted targets,
and original selection, scrolling, variable geometry and nested control input.


## Marker row membership during synchronous clear

FIRST is shared ListView's markerRow selection policy and refreshMarker, including
the model-revision repair above and Edi's existing Base mirror. A derived QML
binding can still expose its previous row while native removal/count callbacks
are synchronously evaluating that binding. A live QObject or surviving delegate
alone does not establish current model membership after a clear.

One currentMarkerRow function owns the original backend-current-row versus sole
selection policy. It returns no row for an empty view and bounds either source
against the actual safe native count. The readonly markerRow still binds to that
one policy, while refreshMarker calls the policy directly instead of re-reading
the currently evaluating derived binding. It rechecks that bounded current row,
the model revision, live objects and actual itemAtIndex identity after markerMoves
can synchronously invoke another operation. Out-of-range delegate lookup is never
a marker source; a count-clear can synchronously publish a null marker even if the
old derived property has not settled. No model getter is reintroduced.

Actual delegate coordinates/height, accent movement, backend-row precedence,
multiple selection and anchor/input/selection/focus/scroll behavior remain. This
changes only marker presentation/currentness; it adds no timer, native/private Qt
patch, selection write or recovery operation. Both existing ListView copies carry
the same policy/fences; Edi's null model/typed-header initialization stays exact.

The routed diagnostic observed count zero after clear returned while markerRow
still named a removed row and markerItem retained its surviving delegate. An event
counter firing earlier inside the clear callback does not by itself prove that
target was already retired. This source correction makes no changed-source native
or Mac qualification claim. Independent exercises must cover empty/shrunk/replaced
models, stale selected/backend rows, callback clear/replacement/null successors,
realized-item reuse and original geometry/selection/nested controls. Qt's public
source keeps count null-guarded and itemAtIndex based on realized view items:
https://github.com/qt/qtdeclarative/blob/v6.11.2/src/quick/items/qquickitemview.cpp
