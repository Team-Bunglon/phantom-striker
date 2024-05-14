extends CanvasLayer
class_name MessageBox

@export var line_one: String = "This is a sample text"
@export var line_two: String = "This is a sample text too"
@export var opacity: float = 0.8 ## The opacity of the background panel

@onready var textbox_container = $MessageBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	$MessageBoxContainer/Panel.modulate.a = opacity
	change_text()
	hide_textbox()

func hide_textbox():
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()

func change_text():
	$MessageBoxContainer/MarginContainer/VBoxContainer/Text1.text = line_one
	$MessageBoxContainer/MarginContainer/VBoxContainer/Text2.text = line_two
