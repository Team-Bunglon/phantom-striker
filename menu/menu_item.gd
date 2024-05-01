extends Label

## A selectable label specialized for cursor.
class_name MenuItem

## Play "decrease" sound when the `ui_decrease` is pressed while selecting this item
@export var can_decrease: bool = false

## Emitted when the cursor is pointing at this menu item and the player presses the `ui_accept` button.
signal selected()

## Same as `selected()` but for decreasing value instead with `ui_decrease` button. 
signal decreased()

func select():
	print(name)
	emit_signal("selected")

func decrease():
	print(name + " (decrease)")
	emit_signal("decreased")
