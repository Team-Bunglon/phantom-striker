extends Node2D

@export var direction: Vector2
@export var speed: float = 100.0

@onready var start_point := global_position
@onready var end_point := global_position + direction
@onready var towards_end := true

func _physics_process(delta):
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

