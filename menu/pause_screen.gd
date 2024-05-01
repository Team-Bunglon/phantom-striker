extends Control
class_name PauseScreen

@onready var default_speed = Engine.time_scale

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PauseMenu.visible = false
	$OptionMenu.visible = false

func _set_visible(this: bool, pause: bool, option: bool, confirm_restart: bool, confirm_menu: bool):
	visible = this
	$PauseMenu.visible = pause
	$OptionMenu.visible = option
	$ConfirmRestart.visible = confirm_restart
	$ConfirmMenu.visible = confirm_menu

func _input(event):
	if event.is_action_pressed("pause") and not Global.is_paused:
		get_tree().paused = true
		Audio.play("Accept")
		_set_visible(true, true, false, false, false)
		Global.is_paused = true

func _on_pause_menu_resume_game():
	get_tree().paused = false
	_set_visible(false, false, false, false, false)
	Global.is_paused = false
	
func _on_pause_menu_option():
	_set_visible(true, false, true, false, false)

func _on_pause_menu_restart_game():
	_set_visible(true, false, false, true, false)

func _on_pause_menu_main_menu():
	_set_visible(true, false, false, false, true)

func _on_confirm_restart_yes_selected():
	_on_pause_menu_resume_game()
	get_tree().change_scene_to_file("res://levels/level1.tscn")

func _on_confirm_menu_yes_selected():
	_on_pause_menu_resume_game()
	get_tree().change_scene_to_file("res://menu/title.tscn")

