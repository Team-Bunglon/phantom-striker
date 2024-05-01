extends Label
class_name MenuItem

## Emitted when the cursor is pointing at this menu item and the player presses the `ui_accept` button.
signal selected()

func select():
	print(name)
	emit_signal("selected")
