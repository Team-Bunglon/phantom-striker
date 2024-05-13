extends Node2D

## A more flexible version of the previous MovingHazard
class_name MovingHazardPoint

@export var direction: Vector2 ## The direction is relative from the starting position (where you placed your object)
@export var speed: float = 100.0

@onready var start_point := global_position
@onready var end_point := global_position + direction
@onready var towards_end := true

var hit_player := false

func _physics_process(delta):
	if hit_player:
		$Sprite2D.rotation = 0.0
		return
	$Sprite2D.rotation += speed * delta
	print($Sprite2D.rotation)
	if towards_end:
		global_position.x = move_toward(global_position.x, end_point.x, speed * delta)
		global_position.y = move_toward(global_position.y, end_point.y, speed * delta)
		if global_position == end_point:
			towards_end = false
	else:
		global_position.x = move_toward(global_position.x, start_point.x, speed * delta)
		global_position.y = move_toward(global_position.y, start_point.y, speed * delta)
		if global_position == start_point:
			towards_end = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		hit_player = true
		body.die()
