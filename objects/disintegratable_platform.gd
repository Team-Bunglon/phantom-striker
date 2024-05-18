extends TileMap
class_name DisintegratablePlatform

@export var respawn_timer: float = 5.0	## The time it takes for the tile to respawn after being destroyed.
@export var can_respawn: bool = true
@onready var sprite_preload: Resource = preload("res://objects/disintegratable_sprite.tscn")
@onready var disarea_preload: Resource = preload("res://objects/disintegratable_area.tscn")
@onready var area_preload: Resource = preload("res://objects/tile_area.tscn")
@onready var disintegrating_particle_preload: Resource = preload("res://objects/disintegrating.tscn")

var tiles_breaking: Dictionary = {}
var tiles_entered: Dictionary = {}
var tiles_entered_disarea: Dictionary = {}

enum {
	## The Area2D to check if the character is inside the sprite of the tilemap. 
	AREA, 
	## The Area2D above the tilemap (1px in height) to engage the breaking procedure when being stepped from the top.
	DISAREA} 

func _ready():
	if global_position != Vector2.ZERO:
		assert(false, "DisintegratingPlatform should have (0,0) as its position")
	for coord in get_used_cells(0):
		_create_area(coord, DISAREA)
		tiles_breaking[coord] = false
		tiles_entered[coord] = false
		tiles_entered_disarea[coord] = false

## Function to change the tile atlas to a broken state
func break_platform(coord):
	if tiles_breaking[coord]: return
	tiles_breaking[coord] = true
	tiles_entered[coord] = false

	# Start the disintegrating animation
	Audio.play("Disintegrate")
	set_cell(0, coord, 0, Vector2i(3,0))
	var sprite := _create_sprite(coord)
	await(sprite.animation_finished)

	# Set to broken state and Create area 2D to hold that state when the player is inside. 
	sprite.visible = false
	set_cell(0, coord, 0, Vector2i(4,0))
	_disintegrating_particle_create(coord)

	if not can_respawn:
		sprite.queue_free()
		return

	var area := _create_area(coord, AREA)
	
	# Create timer and wait for respawn
	await(get_tree().create_timer(respawn_timer, false).timeout)
	if tiles_entered[coord]:
		await(area.body_exited)

	# Repawn procedure.
	set_cell(0, coord, 0, Vector2i(0,0))

	# Delete objects and reset some variables
	area.queue_free()
	sprite.queue_free()
	tiles_breaking[coord] = false

	# Restart this function again if the player is still inside the disarea Area2D
	if tiles_entered_disarea[coord]:
		break_platform(coord)

## Particle stuff
func _disintegrating_particle_create(coord: Vector2):
	var disintegrating_particle: Disintegrating = disintegrating_particle_preload.instantiate()
	var pos: Vector2 = coord * 16 + Vector2(8, 8)
	disintegrating_particle.emitting(pos)
	get_parent().add_child(disintegrating_particle)

## Create animated sprite. We have to create animation from each tile.
func _create_sprite(coord) -> AnimatedSprite2D:
	var sprite: AnimatedSprite2D = sprite_preload.instantiate()
	sprite.global_position = map_to_local(coord)
	sprite.play()
	add_child(sprite)
	return sprite

## Factory function to create the area you need
func _create_area(coord: Vector2i, area_enum) -> Area2D:
	var area: Area2D
	if area_enum == AREA:
		area = area_preload.instantiate()
		area.connect("body_entered", func(body): 
			if body.name == "Player":
				tiles_entered[coord] = true
			)
		area.connect("body_exited", func(body): 
			if body.name == "Player":
				tiles_entered[coord] = false
			)
	elif area_enum == DISAREA:
		area = disarea_preload.instantiate()
		area.connect("body_entered", func(body):
			var coord_new := local_to_map(area.global_position + Vector2(1,0))
			if body.name == "Player":
				tiles_entered_disarea[coord_new] = true
				break_platform(coord_new)
			)
		area.connect("body_exited", func(body):
			var coord_new := local_to_map(area.global_position + Vector2(1,0))
			if body.name == "Player":
				tiles_entered_disarea[coord_new] = false
			)
	area.global_position = map_to_local(coord)
	add_child(area)
	return area
