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
	
	var strike_dir = strike_gravity(rot)
	$StrikeBase.process_material.gravity = strike_dir
	$StrikeParticle.process_material.gravity = strike_dir
	
	$StrikeBase.emitting = true
	$StrikeParticle.emitting = true
	$StrikeParticleSub.emitting = true

func strike_gravity(rot: float):
	const force = 200
	var deg = round(rad_to_deg(rot))
	var vector = Vector3(0, 0, 0)
	if deg == 0 or abs(deg) == 45:
		vector.y = force
	if abs(deg) == 180 or abs(deg) == 135:
		vector.y = -force
	if deg > 0 and deg < 180:
		vector.x = -force
	if deg < 0 and deg > -180:
		vector.x = force
	return vector

func _on_strike_particle_finished():
	queue_free()

