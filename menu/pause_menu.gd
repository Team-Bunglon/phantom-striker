extends Control
class_name PauseMenu

signal option()
signal resume_game()
signal restart_game()
signal main_menu()

func _on_options_selected():
	emit_signal("option")

func _on_resume_selected():
	emit_signal("resume_game")

func _on_restart_game_selected():
	emit_signal("restart_game")

func _on_main_menu_selected():
	emit_signal("main_menu")
