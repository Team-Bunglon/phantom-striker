extends Node2D
class_name Disintegrating


func emitting(pos: Vector2):
	global_position = pos
	$DisintegrateParticle.emitting = true


func _on_disintegrate_particle_finished():
	queue_free()
