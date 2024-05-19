extends Area2D
class_name Mystery

func _ready():
	$AnimationPlayer.play("off")

func _on_body_entered(body:Node2D):
	if body.name == "Player": $AnimationPlayer.play("on")

func _on_body_exited(body:Node2D):
	if body.name == "Player": $AnimationPlayer.play("off")


