extends Node2D
class_name BackgroundImage

@export var show_sub: bool = true

func _ready():
	if not show_sub:
		$BackgroundSub.visible = false
