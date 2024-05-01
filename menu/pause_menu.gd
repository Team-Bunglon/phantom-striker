extends Control
class_name PauseMenu

signal resume_game()

func _on_options_selected():
	visible = false
	$"../OptionMenu".visible = true

func _on_resume_selected():
	emit_signal("resume_game")
