extends Node2D


@export var direction : String = "up"

@onready var anim_player = $MovingHazard/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match direction:
		"up":
			anim_player.play("up")
		"down":
			anim_player.play("down")
		"left":
			anim_player.play("left")
		"right":
			anim_player.play("right")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.die()
