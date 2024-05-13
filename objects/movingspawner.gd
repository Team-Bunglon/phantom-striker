extends Marker2D

class_name MovingSpawner

enum OBJ {PLATFORM, HAZARD}
@export var object_to_spawn: OBJ
@export var direction: Vector2 ## The direction you want to give to the spawned object
@export var speed: float = 100.0
@export var frequency: float = 1.0

@onready var platform_preload: Resource = preload("res://objects/movingplatformpoint.tscn")
@onready var hazard_preload: Resource = preload("res://objects/movinghazardpoint.tscn")
@onready var first_spawn: bool = false

func _physics_process(_delta):
	if not first_spawn: _spawn_object()

func _spawn_object():
	first_spawn = true

	match object_to_spawn:
		OBJ.PLATFORM:
			var object_moving: MovingPlatformPoint = platform_preload.instantiate()
			object_moving.create(global_position, direction, speed, "MovingPlatformPoint")
			get_parent().add_child(object_moving)
		OBJ.HAZARD:
			var object_moving: MovingHazardPoint = hazard_preload.instantiate()
			object_moving.create(global_position, direction, speed, "MovingHazardPoint")
			get_parent().add_child(object_moving)

	await(get_tree().create_timer(frequency).timeout)

	_spawn_object()
