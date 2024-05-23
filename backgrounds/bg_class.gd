extends Node2D
class_name BackgroundImage

## Extra Background
enum BG {
	## BackgroundSub Sprite2D
	SUB = 0,
	## BackgroundAlt Sprite2D
	ALT = 1,
	## No extra background Sprite2D
	NONE = -1
}

@export var sub_or_alt: BG

@onready var bg_sub: Sprite2D = get_node_or_null("BackgroundSub")
@onready var bg_alt: Sprite2D = get_node_or_null("BackgroundAlt")

func _ready():
	_set_extra_bg(sub_or_alt)

func _set_extra_bg(val: int):
	var bool_arr: Array[bool] = []
	bool_arr.resize(len(BG))
	bool_arr.fill(false)

	if val != -1:
		bool_arr[val] = true

	if bg_sub != null: bg_sub.visible = bool_arr[0]
	if bg_alt != null: bg_alt.visible = bool_arr[1]
