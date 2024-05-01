extends Control
class_name OptionMenu

@export var return_object: NodePath 
@export var default_resolution: Vector2i = Vector2i(640, 480)
@export var default_scaling: int = 1
@export var fullscreen: bool = false

@onready var scaling_value_text: Label = find_child("ScalingValue")
@onready var return_node := get_node(return_object)
@onready var maximum_scaling: int

func _ready():
	_get_maximum_scaling()
	default_scaling = maximum_scaling
	_update_value("scaling")

func _get_maximum_scaling():
	var screen_resolution := DisplayServer.screen_get_size()
	var scale_x := screen_resolution.x / default_resolution.x
	var scale_y := screen_resolution.y / default_resolution.y
	maximum_scaling = min(scale_x, scale_y)
	print(maximum_scaling)

func _update_resolution(scaling: int):
	var new_resolution = Vector2i(default_resolution.x * scaling, default_resolution.y * scaling)
	if DisplayServer.window_get_mode() == 0:
		DisplayServer.window_set_size(new_resolution)

func _update_value(setting_name: String):
	if setting_name == "scaling":
		scaling_value_text.text = str(default_scaling) + "x"
		_update_resolution(default_scaling)

func _on_scaling_selected():
	default_scaling += 1
	if default_scaling > maximum_scaling:
		default_scaling = 1
	_update_value("scaling")

func _on_return_selected():
	return_node.visible = true
	visible = false

