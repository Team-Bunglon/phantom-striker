extends Node2D
class_name OldPlatform

@export var direction : String = "up"

@onready var anim_player = $MovingPlatform/AnimationPlayer

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
