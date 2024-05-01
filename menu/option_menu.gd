extends Control
class_name OptionMenu

@export var return_object: NodePath 
@export var default_resolution: Vector2i = Vector2i(640, 480)
@export var default_scaling: int = 1
@export var fullscreen: bool = false
@export var apply_immediately: bool = false

@onready var scaling_value_text: Label = find_child("ScalingValue")
@onready var fullscreen_text: Label = find_child("FullscreenValue")
@onready var return_node := get_node(return_object)

func _ready():
	_get_maximum_scaling()
	_ready_text()
	if apply_immediately:
		Global.current_scaling = default_scaling
		Global.fullscreen = "Yes" if fullscreen else "No"
		_update_value("scaling")
		if fullscreen:
			_update_value("fullscreen")

func _ready_text():
	scaling_value_text.text = str(Global.current_scaling) + "x"
	fullscreen_text.text = Global.fullscreen

func _get_maximum_scaling():
	if Global.maximum_scaling == 0:
		var screen_resolution := DisplayServer.screen_get_size()
		var scale_x := screen_resolution.x / default_resolution.x
		var scale_y := screen_resolution.y / default_resolution.y
		Global.maximum_scaling = min(scale_x, scale_y)

func _update_resolution(scaling: int):
	var new_resolution = Vector2i(default_resolution.x * scaling, default_resolution.y * scaling)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(new_resolution)
		var center_x: int = (DisplayServer.screen_get_size().x - new_resolution.x) / 2
		var center_y: int = (DisplayServer.screen_get_size().y - new_resolution.y) / 2
		DisplayServer.window_set_position(Vector2i(center_x,center_y))

func _update_value(setting_name: String):
	if setting_name == "scaling":
		scaling_value_text.text = str(Global.current_scaling) + "x"
		_update_resolution(Global.current_scaling)
	elif setting_name == "fullscreen":
		if Global.fullscreen == "No":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen_text.text = "Yes"
			Global.fullscreen = "Yes"
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			_update_resolution(Global.current_scaling)
			fullscreen_text.text = "No"
			Global.fullscreen = "No"

func _on_fullscreen_selected():
	_update_value("fullscreen")

func _on_scaling_selected():
	Global.current_scaling += 1
	if Global.current_scaling > Global.maximum_scaling:
		Global.current_scaling = 1
	_update_value("scaling")

func _on_scaling_decreased():
	Global.current_scaling -= 1
	if Global.current_scaling <= 0:
		Global.current_scaling = Global.maximum_scaling
	_update_value("scaling")

func _on_return_selected():
	visible = false
	return_node.visible = true



