extends CanvasLayer
class_name PauseScreenGlobal

@onready var default_speed = Engine.time_scale

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_set_visible(false, false, false, false, false)

func _input(event):
	if event.is_action_pressed("pause") and not Global.is_paused and Global.game_running:
		GameStopwatch.paused = true
		get_tree().paused = true
		Audio.play("Accept")
		_update_text()
		_set_visible(true, true, false, false, false)
		Global.is_paused = true

## this: The pause screen itself
## pause: pause menu (the one you select with your cursor in the pause screen)
## option: option menu (the same one from the title)
## confirm_restart: confirmation menu for resetting the game
## confirm_menu: confirmation menu for going back to main menu
func _set_visible(this: bool, pause: bool, option: bool, confirm_restart: bool, confirm_menu: bool):
	visible = this
	$PauseMenu.visible = pause
	$OptionMenu.visible = option
	$ConfirmRestart.visible = confirm_restart
	$ConfirmMenu.visible = confirm_menu

func _update_text():
	$"HBoxCount/LabelDeath".text = str(Global.death_count)
	$"HBoxCount/LabelCollect".text = str(Global.collectibles)
	$"HBoxCount/LabelTime".text = GameStopwatch.get_elapsed_time_as_formatted_string("{MM}:{ss}")

func _on_pause_menu_resume_game():
	get_tree().paused = false
	_set_visible(false, false, false, false, false)
	GameStopwatch.paused = false
	Global.is_paused = false
	
func _on_pause_menu_option():
	$"OptionMenu/Cursor".cursor_index = 0
	_set_visible(true, false, true, false, false)

func _on_pause_menu_restart_game():
	_set_visible(true, false, false, true, false)

func _on_pause_menu_main_menu():
	_set_visible(true, false, false, false, true)

func _on_confirm_restart_yes_selected():
	_on_pause_menu_resume_game()
	Global.reset_global_value()
	$"PauseMenu/Cursor".cursor_index = 0
	$"ConfirmRestart/Cursor".cursor_index = 0
	get_tree().change_scene_to_file("res://levels/level1.tscn")

func _on_confirm_menu_yes_selected():
	_on_pause_menu_resume_game()
	$"PauseMenu/Cursor".cursor_index = 0
	$"ConfirmMenu/Cursor".cursor_index = 0
	# Quitting the game is equivalent to restarting the game, which counts as death
	Global.death_count += 1
	get_tree().change_scene_to_file("res://menu/title.tscn")

func _on_option_menu_visibility_changed():
	if $OptionMenu.visible:
		$OptionMenu.update_text()
		$Title.text = "OPTIONS"
		$HBoxCount.visible = false
	else:
		_update_text()
		$Title.text = "PAUSED"
		$HBoxCount.visible = true

func _on_confirm_restart_visibility_changed():
	if $ConfirmRestart.visible:
		$Title.visible = false
		$HBoxCount.visible = false
	else:
		_update_text()
		$Title.visible = true
		$HBoxCount.visible = true

func _on_confirm_menu_visibility_changed():
	if $ConfirmMenu.visible:
		$Title.visible = false
		$HBoxCount.visible = false
	else:
		_update_text()
		$Title.visible = true
		$HBoxCount.visible = true

