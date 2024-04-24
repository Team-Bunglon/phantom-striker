extends Control

func _ready():
	$AnimationPlayer.play("idle")

func _start_level(level_name: String):
	Audio.play("Start")
	Global.death_count = 0
	get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")

func _input(event):
	if event.is_action_pressed("start_game"):
		_start_level("level1")
	elif event.is_action_pressed("debug"):
		_start_level("level0")
