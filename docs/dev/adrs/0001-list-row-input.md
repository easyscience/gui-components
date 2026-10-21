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
