extends CanvasLayer
class_name MainScreen

@export var debug_level: int = 0 ## Get to the specific level from the main screen for debugging purpose.

var finish_intro = false

func _ready():
	$AnimationPlayer.play("intro")
	$TitleFg.play("default")
	$Version.text = $Version.text + " " + ProjectSettings.get_setting("application/config/version")
	Global.game_running = false
	GameStopwatch.paused = true
	Audio.music_play("MusicMenu", false)

func _input(event):
	if event.is_action_pressed("ui_accept") and not finish_intro:
		finish_intro = true
		$AnimationPlayer.play("idle")
	if event.is_action_pressed("debug") and Global.debug_mode:
		_start_level("level" + str(debug_level))

func _start_level(level_name: String, new_game := true):
	if new_game:
		Global.has_started_game = true
		Global.reset_global_value()
	Global.game_running = true
	GameStopwatch.paused = false
	get_tree().change_scene_to_file("res://levels/" + level_name + ".tscn")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "intro":
		finish_intro = true
		$AnimationPlayer.play("idle")
	elif anim_name == "fade_out":
		_start_level("level1")
	elif anim_name == "fade_out_continue":
		Global.transition_animation = false
		_start_level("level" + str(Global.current_level), false)

func _on_main_menu_continue_game():
	Global.transition_animation = true
	Global.is_starting_new_game = true
	Audio.play("Start")
	$AnimationPlayer.play("fade_out_continue")

func _on_main_menu_start_game():
	if Global.has_started_game:
		Audio.play("Accept")
		$MainMenu.visible = false
		$ConfirmStart.visible = true
	else:
		$AnimationPlayer.play("prologue")

func _on_main_menu_option():
	$"OptionMenu/Cursor".cursor_index = 0
	$MainMenu.visible = false
	$OptionMenu.visible = true

func _on_main_menu_quit():
	$MainMenu.visible = false
	$ConfirmQuit.visible = true

func _on_confirm_start_yes_selected():
	$ConfirmStart.visible = false
	$AnimationPlayer.play("prologue")

func _on_confirm_quit_yes_selected():
	get_tree().quit()

func _on_prologue_start_game():
	Global.is_starting_new_game = true
	Audio.play("Begin")
	$AnimationPlayer.play("fade_out")

