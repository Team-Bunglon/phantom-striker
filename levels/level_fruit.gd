extends Level

func _ready():
	Audio.music_pause()

func _on_fruit_of_life_you_win():
	$"Player/Camera2D".shake(24,6)
	$AnimationPlayer.play("win")

func _on_fruit_of_life_finished_win():
	$AnimationPlayer.play("finish")

