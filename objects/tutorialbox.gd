extends Area2D
class_name TutorialBox

@export var message_object: NodePath 
@onready var message_node: MessageBox

## You really, really shouldn't search the message box node
## every single time the player approaches the tutorial box.
## Do it on _ready() and save the tutorial box in a variable somewhere.
func _ready():
	if message_object.is_empty():
		message_node = get_parent().get_node_or_null("MessageBox")
		if message_node == null:
			assert(false, "Please add the MessageBox scene into your level.")
	else:
		message_node = get_node(message_object)

func _on_body_entered(body):
	if (body.name == "Player"):
		$Sprite2D.frame = 1
		message_node.show_textbox()

func _on_body_exited(body):
	if (body.name == "Player"):
		$Sprite2D.frame = 0
		message_node.hide_textbox()
