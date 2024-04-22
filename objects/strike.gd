extends Node2D
class_name Strike

@onready var default_length: float = 48

func get_default_length():
	return default_length

func set_default_length(max_length: float):
	$StrikeParticle.position.y = max_length
	$StrikeParticleSub.position.y = max_length
	$StrikeParticle.process_material.emission_box_extents.y = max_length
	$StrikeParticleSub.process_material.emission_box_extents.y = max_length

func emitting(pos: Vector2, rot: float, length: float):
	global_position = pos
	rotation = rot
	$StrikeParticle.position.y = length
	$StrikeParticleSub.position.y = length
	$StrikeParticle.process_material.emission_box_extents.y = length
	$StrikeParticleSub.process_material.emission_box_extents.y = length
	$StrikeParticle.emitting = true
	$StrikeParticleSub.emitting = true

func _on_strike_particle_finished():
	queue_free()

