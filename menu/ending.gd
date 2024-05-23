extends Control
class_name Credit

@onready var can_spook: bool = true

func _ready():
	Audio.music_play("MusicCredit")
	$AnimationPlayer.play("start")

	$"Stats/HBoxContainer4/TotalTime".text = str(GameStopwatch.get_elapsed_time_in_seconds())
	$"Stats/HBoxContainer5/TotalCollectibles".text = str(Global.collectibles)
	$"Stats/HBoxContainer6/TotalDeaths".text = str(Global.death_count)

func _input(event):
	if event.is_action_pressed("ui_accept") and $Timer.is_stopped() and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("end")
	if event.is_action_pressed("secret") and not $AnimationPlayer.is_playing() and can_spook:
		can_spook = false
		Audio.play("Boo")
		$AnimationPlayer.play("spooky")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		$Timer.start()
	elif anim_name == "end":
		get_tree().change_scene_to_file("res://menu/credit_text.tscn")

func _on_timer_timeout():
	$AnimationText.play("idle")
