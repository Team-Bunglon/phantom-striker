extends Area2D
class_name TriggerBox

## Emitted when the player touches the box. Only trigger once.
signal triggered()
var is_triggered: bool = false

func _ready():
	$Sprite2D.frame = 0

func _on_body_entered(body:Node2D):
	if body.name == "Player" and not is_triggered:
		Audio.play("Trigger")
		$Sprite2D.frame = 1
		is_triggered = true
		disconnect("body_entered", _on_body_entered)
		emit_signal("triggered")

