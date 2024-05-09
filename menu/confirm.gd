extends Control
class_name Confirm ## Menu for confirmation

@export var return_object: NodePath		## The menu object the player will return to when they click the return button.
@export var line1_text: String = "Are you sure you want to do something?" ## First line of the confirmation message
@export var line2_text: String = "ALL PROGRESS WILL BE LOST!"			  ## Second line of the confirmation message
@export var line2_is_red: bool = false	## Self explanatory. Used to make the secoind line as a warning message.

@onready var return_node := get_node(return_object)

signal yes_selected()

func _ready():
	$Warning1.text = line1_text
	$Warning2.text = line2_text
	if line2_is_red:
		$Warning2.set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))

func _on_yes_selected():
	emit_signal("yes_selected")

func _on_no_selected():
	$Cursor.cursor_index = 0
	visible = false
	return_node.visible = true
