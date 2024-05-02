extends Control
class_name MainMenu

func _start_level(level_name: String):
	Audio.play("Start")
	Global.death_count = 0
	Global.game_running = true
	# The weirdest thing is that to "Start" a stopwatch, you have to unpause it 
	# since it is already has the elapsed time of 0 seconds from the time this node gets initialzied.
	GameStopwatch.toggle_pause() 
	get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")

func _input(event):
	if event.is_action_pressed("debug"):
		_start_level("level0")

func _on_start_selected():
	_start_level("level1")

func _on_options_selected():
	visible = false
	$"../OptionMenu".visible = true

func _on_exit_selected():
	get_tree().quit()
