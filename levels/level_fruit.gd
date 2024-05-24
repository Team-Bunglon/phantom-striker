extends Level

func _on_fruit_of_life_you_win():
	$"Player/Camera2D".shake(24,6)
	$AnimationPlayer.play("win")

func _on_fruit_of_life_finished_win():
	$AnimationPlayer.play("finish")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "finish":
		Global.has_started_game = false
		get_tree().change_scene_to_file("res://menu/ending.tscn")
