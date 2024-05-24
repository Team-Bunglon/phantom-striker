extends Level

func _ready():
	if Global.is_starting_new_game:
		$AnimationPlayer.play("fade_in")
		Global.is_starting_new_game = false
		$LevelNotification.set_timer(2.4)
	else:
		$"LevelIntro/TextureRect".visible = false

	super._ready()

func _input(event):
	if event.is_action_pressed("pause") and $AnimationPlayer.is_playing():
		$LevelNotification.set_timer(1)
		$AnimationPlayer.stop()
		$"LevelIntro/TextureRect".visible = false

