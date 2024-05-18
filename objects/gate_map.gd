extends TileMap
class_name GateMap

## How many keys the player needs to collect before opening the gate? [br][br]
## In order for the gate to be functional, you need to add [GateKey] to your level and assign them to this GateMap.
## Make sure there are as many GateKey as the ammount set in [param key_count].
@export var key_count: int = 1								  
@export var fade_duration: float = 2.0						  ## How long the fading animation would last. Note that the collision is disable as soon as the last key is collected.
@export var color_modulate: Color = Color(0.5, 0.5, 0.5, 0.5) ## The color modulation after the gate is opened

var current_count: int = 0
var is_opened: bool = false

func _ready():
	if key_count == 0:
		is_opened = true
		tile_set.set_physics_layer_collision_mask(0,0)
		tile_set.set_physics_layer_collision_layer(0,0)
		z_index = -2
		modulate = color_modulate
	else:
		tile_set.set_physics_layer_collision_mask(0,1)
		tile_set.set_physics_layer_collision_layer(0,1)
		z_index = 0

## Increase [param current_count] on the gate map by one.
## If [param current_count] is equal to the amount set for [param key_count], the gate will unlock, disabling all of its collision.
func unlock():
	current_count += 1
	if current_count >= key_count and not is_opened:
		is_opened = true
		Audio.play("Open")
		tile_set.set_physics_layer_collision_mask(0,0)
		tile_set.set_physics_layer_collision_layer(0,0)
		z_index = -2
		var opacity_tween := create_tween()
		opacity_tween.tween_property(self, "modulate", color_modulate, fade_duration)

