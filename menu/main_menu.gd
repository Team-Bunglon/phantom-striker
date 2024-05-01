extends Control
class_name MainMenu

func _start_level(level_name: String):
	Audio.play("Start")
	Global.death_count = 0
	get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")

func _input(event):
	if event.is_action_pressed("debug"):
		_start_level("level0")

func _on_start_selected():
	_start_level("level1")

func _on_exit_selected():
	get_tree().quit()
