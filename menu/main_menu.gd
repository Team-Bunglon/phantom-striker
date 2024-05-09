extends Control
class_name MainMenu

@export var debug_level: int = 0

func enable_cursor():
	$Cursor.cursor_can_choose = true

func _ready():
	if Global.has_started_game: 
		$"HBoxContainer/MarginContainer/VBoxContainer/Continue".set_selectable(true)
		$Cursor.cursor_index = 0
	else:
		$"HBoxContainer/MarginContainer/VBoxContainer/Continue".set_selectable(false)
		$Cursor.cursor_index = 1

func _start_level(level_name: String, new_game := true):
	if new_game:
		Global.reset_global_value()
	Audio.play("Start")
	Audio.music_play("Music1")
	Global.game_running = true
	# The weirdest thing is that to "Start" a stopwatch, you have to unpause it 
	# since it is already has the elapsed time of 0 seconds from the time this node gets initialzied.
	GameStopwatch.paused = false
	get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")

func _input(event):
	if event.is_action_pressed("debug"):
		_start_level("level" + str(debug_level))

func _on_start_selected():
	Global.has_started_game = true
	_start_level("level1")

func _on_continue_selected():
	_start_level("level" + str(Global.current_level), false)

func _on_options_selected():
	visible = false
	$"../OptionMenu/Cursor".cursor_index = 0
	$"../OptionMenu".visible = true

func _on_exit_selected():
	get_tree().quit()


