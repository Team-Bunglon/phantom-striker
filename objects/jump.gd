extends Node2D
class_name Jump


func emitting(pos: Vector2, dir: float):
	global_position = pos
	
	if dir > 0:  # right
		print("right")
		rotation = deg_to_rad(45)
		$JumpParticle.process_material.gravity = Vector3(-25, 25, 0)
	elif dir < 0:  # left
		print("left")
		rotation = deg_to_rad(-45)
		$JumpParticle.process_material.gravity = Vector3(25, 25, 0)
	else:
		print("mid")
		rotation = 0
		$JumpParticle.process_material.gravity = Vector3(0, 50, 0)
	
	$JumpParticle.emitting = true


func _on_jump_particle_finished():
	queue_free()
