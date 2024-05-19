extends MovingSpawner
class_name MovingSpawnerLine ## Spawn moving object in a line

@export var gap: float = 24
@export var line_direction: Vector2
@export var line_marker_object: NodePath 
@onready var line_marker_node: Marker2D

func _ready():
	if not line_marker_object.is_empty():
		line_marker_node = get_node(line_marker_object)
		line_direction = line_marker_node.global_position - global_position
	super._ready()

func _spawn_object_on_process():
	_spawn_object(global_position, direction, speed)
	_spawn_object_on_line(line_direction.normalized() * gap, line_direction)
	await(get_tree().create_timer(frequency, false).timeout)
	can_spawn = true
