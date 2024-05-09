extends Label
class_name MenuItem ## A selectable label specialized for cursor.

@export var selectable: bool = true ## Allow item to be selectable. If false, the item will be greyed out.
@export var can_decrease: bool = false ## Allow item to react with `decreased()` signal when `ui_decrease` is pressed.
@export var can_increase: bool = false ## Allow item to react with `increased()` signal when `ui_increase` is pressed.

signal selected() ## Emitted when the cursor is pointing at this menu item and the player presses the `ui_accept` button.
signal increased() ## Same as `selected()` but for increasing value instead with `ui_decrease` button. 
signal decreased() ## Same as `selected()` but for decreasing value instead with `ui_decrease` button. 

func _ready():
	set_selectable(selectable)
	
## Use this to make the option unselectable. This will make 
func set_selectable(value: bool):
	if value:
		set("theme_override_colors/font_color", Color(1.0,1.0,1.0,1.0))
	else:
		set("theme_override_colors/font_color", Color(0.4,0.4,0.4,1.0))
	selectable = value

func select():
	if selectable: emit_signal("selected")

func increase():
	if selectable: emit_signal("increased")

func decrease():
	if selectable: emit_signal("decreased")
