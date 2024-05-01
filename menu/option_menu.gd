extends Control
class_name OptionMenu

@export var return_object: NodePath 
@export var default_resolution: Vector2i = Vector2i(640, 480)
@export var default_scaling: int = 1
@export var fullscreen: bool = false

@onready var scaling_value_text: Label = find_child("ScalingValue")
@onready var fullscreen_text: Label = find_child("FullscreenValue")
@onready var return_node := get_node(return_object)
@onready var maximum_scaling: int

func _ready():
	_get_maximum_scaling()
	_update_value("scaling")
	print(fullscreen)
	if fullscreen:
		_update_value("fullscreen")

func _get_maximum_scaling():
	var screen_resolution := DisplayServer.screen_get_size()
	var scale_x := screen_resolution.x / default_resolution.x
	var scale_y := screen_resolution.y / default_resolution.y
	maximum_scaling = min(scale_x, scale_y)

func _update_resolution(scaling: int):
	var new_resolution = Vector2i(default_resolution.x * scaling, default_resolution.y * scaling)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(new_resolution)
		var center_x: int = (DisplayServer.screen_get_size().x - new_resolution.x) / 2
		var center_y: int = (DisplayServer.screen_get_size().y - new_resolution.y) / 2
		DisplayServer.window_set_position(Vector2i(center_x,center_y))

func _update_value(setting_name: String):
	if setting_name == "scaling":
		scaling_value_text.text = str(default_scaling) + "x"
		_update_resolution(default_scaling)
	elif setting_name == "fullscreen":
		if fullscreen_text.text == "No":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen_text.text = "Yes"
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen_text.text = "No"
			_update_resolution(default_scaling)

func _on_fullscreen_selected():
	_update_value("fullscreen")

func _on_scaling_selected():
	default_scaling += 1
	if default_scaling > maximum_scaling:
		default_scaling = 1
	_update_value("scaling")

func _on_return_selected():
	visible = false
	return_node.visible = true

