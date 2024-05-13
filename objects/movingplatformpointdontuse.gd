extends Node2D
## You agree to not kill the character when he's squeezed, right?
class_name MovingPlatformThatCanKillYouButLetsJustNotUseIt

@export var direction: Vector2
@export var speed: float = 100.0
@export var kill_player_when_squeezed: bool = false

@onready var start_point := global_position
@onready var end_point := global_position + direction
@onready var towards_end := true

var player_node: Player
var player_inside: Array[String] = []

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

func _on_death_area_6_body_exited(body:Node2D):
	_on_death_area_1_body_exited(body)

func _on_death_area_6_body_entered(body:Node2D):
	_on_death_area_1_body_entered(body)

func _on_death_area_5_body_exited(body:Node2D):
	_on_death_area_1_body_exited(body)

func _on_death_area_5_body_entered(body:Node2D):
	_on_death_area_1_body_entered(body)

func _on_death_area_4_body_exited(body:Node2D):
	_on_death_area_1_body_exited(body)

func _on_death_area_4_body_entered(body:Node2D):
	_on_death_area_1_body_entered(body)

func _on_death_area_3_body_exited(body:Node2D):
	_on_death_area_1_body_exited(body)

func _on_death_area_3_body_entered(body:Node2D):
	_on_death_area_1_body_entered(body)

func _on_death_area_2_body_exited(body:Node2D):
	_on_death_area_1_body_exited(body)

func _on_death_area_2_body_entered(body:Node2D):
	_on_death_area_1_body_entered(body)

func _on_death_area_1_body_exited(body:Node2D):
	if body.name == "Player":
		player_inside.pop_back()
		if player_inside.is_empty():
			player_node = null

func _on_death_area_1_body_entered(body:Node2D):
	if body.name == "Player":
		if player_inside.is_empty():
			player_node = body
		player_inside.push_back(body.name)
	else:
		if kill_player_when_squeezed and player_node != null:
			player_node.die(true)

