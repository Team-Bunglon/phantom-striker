extends AnimatableBody2D

## The parent class that holds the main information for both MovingPlatform and Moving Hazard
class_name Moving

@export var direction: Vector2		## The direction is relative from the starting position (where you placed your object)
@export var speed: float = 100.0	## The speed of which the object is moving
@export var back_and_forth: bool = true	## Should the object go back to its starting position? If not, it'll delete itself when it reaches its destination.

@onready var start_point := global_position
@onready var end_point := global_position + direction
@onready var towards_end := true

var prev_position := global_position
var strike_name = name

func _physics_process(delta):
	_move(delta)

func _move(delta):
	prev_position = global_position
	if towards_end:
		global_position = global_position.move_toward(end_point, speed * delta)
		if global_position == end_point:
			if not back_and_forth:
				queue_free()
			towards_end = false
	else:
		global_position = global_position.move_toward(start_point, speed * delta)
		if global_position == start_point:
			towards_end = true

## Create a Moving object for automatic spawning purposes.
func create(start: Vector2, dir: Vector2, spd: float, obj_name: String):
	back_and_forth = false
	global_position = start
	direction = dir
	speed = spd
	strike_name = obj_name

## For object spawned using a spawner, we have to set the name manually to have it detected by our strike.
func get_strike_name():
	return strike_name

## For debugging purpose
func calculate_distance(time: float, msg := ""):
	var start_x := global_position.x
	var start_y := global_position.y
	await(get_tree().create_timer(time).timeout)
	var end_x := global_position.x
	var end_y := global_position.y
	print(msg + " Dist.x: " + str(abs(end_x - start_x)) + " | Dist.y: " + str(abs(end_y - start_y)))
