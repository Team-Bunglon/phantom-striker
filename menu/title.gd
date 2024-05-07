extends CanvasLayer

# Every input is controlled at main_menu
# TODO: I'll return to this later when I'm adding animation
func _ready():
	$AnimationPlayer.play("intro")
	$TitleFg.play("default")
	$Version.text = $Version.text + " " + ProjectSettings.get_setting("application/config/version")
	Global.game_running = false
	Audio.music_play("MusicMenu")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("idle")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "intro":
		$AnimationPlayer.play("idle")
	pass # Replace with function body.

