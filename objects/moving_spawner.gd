extends Marker2D
class_name MovingSpawner ## A Marker2D specialized to spawn Moving Platform and Moving Hazard. 

enum OBJ {
	## A moving platform for the character to stand and strike on.
	PLATFORM, 
	## A moving hazard that can kill the character on contact.
	HAZARD
}

@export var auto_start: bool = true ## Start spawning object on scene ready. If disabled and reneabled later, [param auto_spawn] will always be set to false.
@export var object_to_spawn: OBJ	## Select which object you want to spawn.
@export var direction: Vector2		## The direction you want to give for the spawned object. The destination point of the spawned objects will be this spawner's [param global_position] + [param direction].
@export var speed: float = 100.0	## The speed you want to give to the spawned object
@export var frequency: float = 1.0	## The frequency of which this spawner creates a new moving object in seconds
@export var marker_object: NodePath ## Alternative way to set the destination point of the spawned object by using another marker node. If a marker node is given, [param direction] will be ignored. To use [param direction], leave this field empty.
@export var auto_spawn: bool = false## Automatically spawn a line of moving objects between the spawner's location and the destination point with the gap of the normalized distance vector between the two points times [param speed] and [param frequency].

@onready var marker_node: Marker2D
@onready var platform_preload: Resource = preload("res://objects/moving_platform_point.tscn")
@onready var hazard_preload: Resource = preload("res://objects/moving_hazard_point.tscn")
@onready var can_spawn: bool = true

func _ready():
	if not marker_object.is_empty():
		marker_node = get_node(marker_object)
		direction = marker_node.global_position - global_position

func _physics_process(_delta):
	if not auto_start:
		auto_spawn = false
		return
	if auto_spawn:
		auto_spawn = false
		_spawn_object_on_line(direction.normalized() * speed * frequency, direction)
	if can_spawn:
		can_spawn = false
		_spawn_object_on_process()

func _spawn_object_on_line(step: Vector2, dir: Vector2):
	var len_to_target := dir.length()
	var current_step := step
	var spawn_pos := global_position + current_step
	var len_to_step := current_step.length()

	while len_to_step <= len_to_target:
		_spawn_object(spawn_pos, direction, speed)
		current_step += step
		spawn_pos = global_position + current_step
		len_to_step = current_step.length()

func _spawn_object_on_process():
	_spawn_object(global_position, direction, speed)
	await(get_tree().create_timer(frequency, false).timeout)
	can_spawn = true # I could use recursion but this is probably the better option.

func _spawn_object(pos: Vector2, dir: Vector2, spd: float):
	match object_to_spawn:
		OBJ.PLATFORM:
			var object_moving: MovingPlatformPoint = platform_preload.instantiate()
			object_moving.create(pos, dir, spd, "MovingPlatformPoint")
			object_moving.add_to_group(name + "Platform")
			get_parent().add_child(object_moving)
		OBJ.HAZARD:
			var object_moving: MovingHazardPoint = hazard_preload.instantiate()
			object_moving.create(pos, dir, spd, "MovingHazardPoint")
			object_moving.add_to_group(name + "Hazard")
			print(name + "Hazard")
			get_parent().add_child(object_moving)

func _on_trigger_box_triggered():
	auto_start = true

func _on_trigger_box_2_triggered():
	_on_trigger_box_triggered()

func _on_trigger_box_3_triggered():
	_on_trigger_box_triggered()

func _on_stop_spawn_platform_area_body_entered(body:Node2D):
	if body.name == "Player":
		get_tree().call_group(name + "Platform", "queue_free")
		queue_free()

func _on_stop_spawn_hazard_area_body_entered(body:Node2D):
	print("nothing")
	if body.name == "Player":
		get_tree().call_group(name + "Hazard", "queue_free")
		queue_free()
