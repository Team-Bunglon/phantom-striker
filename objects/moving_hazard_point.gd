extends Moving

## A more flexible version of the previous MovingHazard
class_name MovingHazardPoint

var rotation_direction: int
var hit_player := false

func _physics_process(delta):
	if hit_player:
		$Sprite2D.rotation = 0.0
		return
	$Sprite2D.rotation += 4 * delta * _get_rotate_direction()
	_move(delta)

func _get_rotate_direction():
	if (global_position.x - prev_position.x) >= 0:
		return 1
	else:
		return -1

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if not body.is_dying:
			hit_player = true
			body.die()
