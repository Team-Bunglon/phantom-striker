extends AnimatableBody2D

## The parent class that holds the main information for both MovingPlatform and Moving Hazard
class_name Moving

@export var direction: Vector2		## The direction for the object to travel to. It is relative from the starting position (where you placed your object in the editor). The destination point will be this object's [param global_position] + [param direction].
@export var speed: float = 100.0	## The speed of which the object is moving. The speed in pixel/frame is [param speed] * [param delta].
@export var back_and_forth: bool = true	## Should the object go back to its starting position once it reaches its destination point? If not, it'll despawn when it reaches its destination. Any objects spawned using [MovingSpawner] will have this parameter set to [code]false[/code].
@export var marker_object: NodePath ## Alternative way to set the destination point by using another marker node. If a marker node is given, [param direction] will be ignored. To use [param direction], leave this field empty.

@onready var marker_node: Marker2D
@onready var start_point := global_position
@onready var end_point := global_position + direction
@onready var towards_end := true

var strike_name = name
var prev_position = global_position

func _ready():
	if not marker_object.is_empty():
		marker_node = get_node(marker_object)
		end_point = marker_node.global_position

func _physics_process(delta):
	if direction == Vector2.ZERO or speed == 0.0:
		return
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
