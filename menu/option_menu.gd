extends Control
class_name OptionMenu

@export var return_object: NodePath		  ## The menu object the player will return to when they click the return button.
@export var volume_max_value: int = 5	  ## The maximum value of the volume. The range would be from 0 to this value with the step of 1. Note that increasing this value doesn't increase the maximum volume, it only makes the audio adjustment more precise.
@export var gamespeed_min_value: int = 50 ## The minimal value of the gamespeed in percent. The maximum value is hardcoded to be 100% for now.
@export var gamespeed_step: int = 10	  ## The value of the gamespeed that the player can adjust.

@onready var default_resolution: Vector2i = Vector2i(640, 480)
@onready var scaling_value_text: Label = find_child("ScalingValue")
@onready var fullscreen_text: Label = find_child("FullscreenValue")
@onready var music_text: Label = find_child("MusicValue")
@onready var sound_text: Label = find_child("SoundValue")
@onready var speed_text: Label = find_child("SpeedValue")
@onready var return_node := get_node(return_object)

func _ready():
	_get_maximum_scaling()
	update_text()
	if not Global.has_applied_setting_on_launch:
		_update_value("music")
		_update_value("sound")
		_update_value("speed")
		_update_value("scaling")
		_update_value("fullscreen", Global.fullscreen)
		Global.has_applied_setting_on_launch = true

func update_text():
	music_text.text = str(Global.music_vol)
	sound_text.text = str(Global.sound_vol)
	scaling_value_text.text = str(Global.current_scaling) + "x"
	fullscreen_text.text = Global.fullscreen
	speed_text.text = str(Global.gamespeed) + "%"

## This should only run once since you won't change your screen resolution midgame anyway.
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

func _update_value(setting_name: String, fullscreen = "No"):
	if setting_name == "scaling":
		_update_resolution(Global.current_scaling)
	elif setting_name == "fullscreen":
		if fullscreen == "Yes":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Global.fullscreen = "Yes"
		elif fullscreen == "No":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			_update_resolution(Global.current_scaling)
			Global.fullscreen = "No"
	elif setting_name == "music":
		var bus_index := AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.music_vol / float(volume_max_value)))
	elif setting_name == "sound":
		var bus_index := AudioServer.get_bus_index("Sound")
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.sound_vol / float(volume_max_value)))
	elif setting_name == "speed":
		Engine.time_scale = Global.gamespeed / 100.0
	update_text()

func _on_scaling_selected():
	Global.current_scaling += 1
	if Global.current_scaling > Global.maximum_scaling:
		Global.current_scaling = 1
	_update_value("scaling")

func _on_scaling_increased():
	_on_scaling_selected()

func _on_scaling_decreased():
	Global.current_scaling -= 1
	if Global.current_scaling <= 0:
		Global.current_scaling = Global.maximum_scaling
	_update_value("scaling")

func _on_fullscreen_selected():
	var fullscreen_new := "Yes" if Global.fullscreen == "No" else "No"
	_update_value("fullscreen", fullscreen_new)

func _on_fullscreen_increased():
	_on_fullscreen_selected()

func _on_fullscreen_decreased():
	_on_fullscreen_selected()

func _on_music_selected():
	if Global.music_vol < volume_max_value:
		Global.music_vol += 1
	_update_value("music")

func _on_music_increased():
	_on_music_selected()

func _on_music_decreased():
	if Global.music_vol > 0:
		Global.music_vol -= 1
	_update_value("music")

func _on_sound_selected():
	if Global.sound_vol < volume_max_value:
		Global.sound_vol += 1
	_update_value("sound")

func _on_sound_increased():
	_on_sound_selected()

func _on_sound_decreased():
	if Global.sound_vol > 0:
		Global.sound_vol -= 1
	_update_value("sound")

func _on_speed_selected():
	if Global.gamespeed < 100:
		Global.gamespeed += gamespeed_step
	_update_value("speed")

func _on_speed_increased():
	_on_speed_selected()

func _on_speed_decreased():
	print("decrease: " + str(Global.gamespeed))
	if Global.gamespeed > gamespeed_min_value:
		Global.gamespeed -= gamespeed_step
	_update_value("speed")

func _on_return_selected():
	visible = false
	return_node.visible = true

