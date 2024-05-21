extends Control
class_name MainMenu

signal option()
signal continue_game()
signal start_game()
signal quit()

func enable_cursor():
	$Cursor.cursor_can_choose = true

func _ready():
	var continue_button: MenuItem = $"HBoxContainer/MarginContainer/VBoxContainer/Continue"
	if Global.has_started_game: 
		continue_button.set_selectable(true)
		$Cursor.cursor_index = 0
	else:
		continue_button.set_selectable(false)
		$Cursor.cursor_index = 1

func _on_continue_selected():
	Global.is_level_notification_appear = true
	emit_signal("continue_game")

func _on_start_selected():
	Global.is_level_notification_appear = true
	emit_signal("start_game")

func _on_options_selected():
	emit_signal("option")

func _on_exit_selected():
	emit_signal("quit")
