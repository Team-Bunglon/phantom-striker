extends Marker2D
class_name MovingSpawner ## A Marker2D specialized to spawn Moving Platform and Moving Hazard. 

enum OBJ {PLATFORM, HAZARD}
@export var object_to_spawn: OBJ
@export var direction: Vector2		## The direction you want to give to the spawned object
@export var speed: float = 100.0	## The speed you want to give to the spawned object
@export var frequency: float = 1.0	## The frequency of which this spawner creates a new moving object in seconds
@export var marker_object: NodePath ## Alternative way to set the final point of the spawned object by using another marker node. If a marker node is given, [param direction] will be ignored. To use [param direction], leave this field empty.

@onready var marker_node: Marker2D
@onready var platform_preload: Resource = preload("res://objects/moving_platform_point.tscn")
@onready var hazard_preload: Resource = preload("res://objects/moving_hazard_point.tscn")
@onready var first_spawn: bool = false

func _ready():
	if not marker_object.is_empty():
		marker_node = get_node(marker_object)
		direction = marker_node.global_position - global_position

func _physics_process(_delta):
	if not first_spawn: _spawn_object()

func _spawn_object():
	first_spawn = true

	match object_to_spawn:
		OBJ.PLATFORM:
			var object_moving: MovingPlatformPoint = platform_preload.instantiate()
			object_moving.create(global_position, direction, speed, "MovingPlatformPoint")
			get_parent().add_child(object_moving)
			#object_moving.calculate_distance(frequency, name)
		OBJ.HAZARD:
			var object_moving: MovingHazardPoint = hazard_preload.instantiate()
			object_moving.create(global_position, direction, speed, "MovingHazardPoint")
			get_parent().add_child(object_moving)
			#object_moving.calculate_distance(frequency, name)

	await(get_tree().create_timer(frequency, false).timeout)

	_spawn_object()
