extends Control
class_name PauseScreen

@onready var default_speed = Engine.time_scale

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PauseMenu.visible = false
	$OptionMenu.visible = false

func _input(event):
	if event.is_action_pressed("pause") and not Global.is_paused:
		get_tree().paused = true
		Audio.play("Accept")
		visible = true
		$PauseMenu.visible = true
		$OptionMenu.visible = false
		Global.is_paused = true

func _on_pause_menu_resume_game():
	get_tree().paused = false
	visible = false
	$PauseMenu.visible = false
	$OptionMenu.visible = false
	Global.is_paused = false

	
