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
