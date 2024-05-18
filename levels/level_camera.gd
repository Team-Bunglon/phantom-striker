extends Camera2D

## A modified Camera2D with shake feature. Call it with .shake()
class_name LevelCamera

@export var shake_strength: float = 10.0 ## How strong the camera shake strength would be
@export var shake_length:	float = 10.0 ## The bigger the value, the shorter the shake duration becomes

var rng = RandomNumberGenerator.new()
var shake_strength_current: float = 0.0
var shake_length_current: float = shake_length

## "Baby, I'm just gonna make the camera shake, shake, shake, shake, shake."[br][br]
## `strength` determines how strong the shake is.
## The bigger the `length`, the shorter the shake effect is applied.
## You can set the default strength and length at the camera2D's exported value
func shake(strength := shake_strength, length := shake_length):
	shake_strength_current = strength
	shake_length_current = length

func _process(delta):
	if shake_strength_current > 0:
		shake_strength_current = lerpf(shake_strength_current, 0, shake_length_current * delta)
		offset = _random_offset()

func _random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength_current, shake_strength_current),
		rng.randf_range(-shake_strength_current, shake_strength_current)
	)

func _on_move_camera_area_area_entered(area:Node2D):
	print(area)
	if area.name == "PlayerPoint":
		global_position.y = -80
		limit_top = -80
		limit_bottom = 400
		position_smoothing_enabled = true
		position_smoothing_speed = 8

func _on_bottom_area_area_entered(area:Node2D):
	if area.name == "PlayerPoint":
		global_position.y = 0
		limit_top = 0
		limit_bottom = 480
		position_smoothing_enabled = true
		position_smoothing_speed = 8

func _on_top_area_area_entered(area:Area2D):
	print(area.name)
	if area.name == "PlayerPoint":
		global_position.y = -480
		limit_top = -480
		limit_bottom = 0
		position_smoothing_enabled = true
		position_smoothing_speed = 8
