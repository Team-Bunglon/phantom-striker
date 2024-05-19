extends Node2D
class_name Respawn


func emitting(pos: Vector2):
	global_position = pos
	$RespawnParticle.emitting = true


func _on_respawn_particle_finished():
	queue_free()
