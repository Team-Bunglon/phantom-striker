extends Moving

## A more flexible version of the previous MovingHazard
class_name MovingHazardPoint

var hit_player := false

func _physics_process(delta):
	if hit_player:
		$Sprite2D.rotation = 0.0
		return
	$Sprite2D.rotation += speed * delta
	_move(delta)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		hit_player = true
		body.die()
