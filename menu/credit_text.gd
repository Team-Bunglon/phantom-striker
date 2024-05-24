extends Control
class_name CreditText

var is_fading: bool = false
var is_scrolling: bool = false

func _ready():
	Audio.music_play("MusicCredit")
	_set_random_bg(randi_range(0,3))

	$"StatTexts/Stats/HBoxCount/LabelDeath".text = str(Global.death_count)
	$"StatTexts/Stats/HBoxCount/LabelCollect".text = str(Global.collectibles) + "/12"
	$"StatTexts/Stats/HBoxCount/LabelTime".text = GameStopwatch.get_elapsed_time_as_formatted_string("{MM}:{ss}")

	if Global.death_count > 0:
		$"StatTexts/Stats/Hardest".text = "Hardest Floor (" + str(Global.hardest_death) + " deaths):"
		$"StatTexts/Stats/LevelName".text = str(Global.hardest_level) + "F - " + Global.hardest
	else:
		$"StatTexts/Stats/Hardest".text = "You beat the game without dying once"
		$"StatTexts/Stats/LevelName".text = "Awesome!"

	is_fading = true
	$AnimationPlayer.play("fade_in")

func _input(event):
	if is_fading:
		return
	if event.is_action_pressed("ui_accept") and is_scrolling:
		$AnimationPlayer.speed_scale = 6
	elif event.is_action_released("ui_accept") and is_scrolling:
		$AnimationPlayer.speed_scale = 1

	if event.is_action_pressed("ui_accept") and $Timer.is_stopped() and not $AnimationPlayer.is_playing() and not is_scrolling:
		is_fading = true
		$AnimationPlayer.play("fade_out")

func _set_random_bg(val: int):
	var bool_arr: Array[bool] = Global.get_visible_array(4, val)
	$BackgroundRoot.visible = bool_arr[0]
	$BackgroundTrunk.visible = bool_arr[1]
	$BackgroundBranch.visible = bool_arr[2] 
	$BackgroundFruit.visible = bool_arr[3]

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "scroll":
		is_scrolling = false
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play("show_final")
	elif anim_name == "fade_in":
		is_fading = false
		is_scrolling = true
		$AnimationPlayer.play("scroll")
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file("res://menu/main_screen.tscn")
	elif anim_name == "show_final":
		$Timer.start()

func _on_timer_timeout():
	$AnimationText.play("idle")

