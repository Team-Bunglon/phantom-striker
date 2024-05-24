extends CanvasLayer
class_name LevelBox

#@export var line_one: String = "This is a sample text"
#@export var line_two: String = "This is a sample text too"
@export var opacity: float = 0.8 ## The opacity of the background panel

@onready var textbox_container = $LevelNotificationContainer
@onready var timer = $Timer

func _ready():
	visible = true
	$LevelNotificationContainer/Panel.modulate.a = opacity
	#change_text()
	hide_textbox()

func hide_textbox():
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()

func translate_group(level_number: int) -> String:
	if (level_number >= 1 && level_number <= 10):
		return "The Root"
	elif (level_number >= 11 && level_number <= 20):
		return "The Trunk"
	elif (level_number >= 21 && level_number <= 30):
		return "The Branch"
	elif (level_number == 31):
		return "The Fruit"
	else:
		return "Forbidden"

func refresh_text():
	$LevelNotificationContainer/MarginContainer/VBoxContainer/Text1.text = translate_group(Global.current_level)
	$LevelNotificationContainer/MarginContainer/VBoxContainer/Text2.text = str(Global.current_level) + "F"

func appear():
	show_textbox()
	timer.start()

func _on_timer_timeout():
	hide_textbox()

func set_timer(val: int):
	timer.stop()
	timer.wait_time = val
	timer.start()
