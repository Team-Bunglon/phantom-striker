extends Label
class_name MenuItem ## A selectable label specialized for cursor.

@export var can_decrease: bool = false ## Allow item to react with `decreased()` signal when `ui_decrease` is pressed.
@export var can_increase: bool = false ## Allow item to react with `increased()` signal when `ui_increase` is pressed.

signal selected() ## Emitted when the cursor is pointing at this menu item and the player presses the `ui_accept` button.
signal increased() ## Same as `selected()` but for increasing value instead with `ui_decrease` button. 
signal decreased() ## Same as `selected()` but for decreasing value instead with `ui_decrease` button. 

func select():
	print(name)
	emit_signal("selected")

func increase():
	print(name + " (increase)")
	emit_signal("increased")

func decrease():
	print(name + " (decrease)")
	emit_signal("decreased")
