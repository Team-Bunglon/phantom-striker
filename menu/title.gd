extends Control

func _ready():
	$AnimationPlayer.play("idle")

func _input(event):
	if event.is_action_pressed("start_game"):
		Global.death_count = 0
		get_tree().change_scene_to_file("res://levels/level1.tscn")
