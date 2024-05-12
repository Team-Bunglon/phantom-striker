extends TileMap

@export var respawn_timer: float = 5.0	## The time it takes for the tile to respawn after being destroyed.
@onready var sprite_preload: Resource = preload("res://objects/disintegratablesprite.tscn")
@onready var disarea_preload: Resource = preload("res://objects/disintegratablearea.tscn")
@onready var area_preload: Resource = preload("res://objects/tilearea.tscn")

var breaking_tile: Dictionary = {}
var respawn_tile: Dictionary = {}

## AREA: The Area2D to check if the character is inside of the tilemap. 
## DISAREA: The Area2D above the tilemap to engage the breaking procedure when being stepped on from the top.
enum {AREA, DISAREA} 

func _ready():
	for coord in get_used_cells(0):
		_create_area(coord, DISAREA)
		breaking_tile[coord] = false

## Function to change the tile atlas to a broken state
func break_platform(coord):
	if breaking_tile[coord]:
		return

	# Set some variables
	breaking_tile[coord] = true
	respawn_tile[coord] = true

	# Start the disintegrating animation
	Audio.play("Disintegrate")
	set_cell(0, coord, 0, Vector2i(3,0))
	var sprite := _create_sprite(coord)
	await(sprite.animation_finished)
	sprite.visible = false

	# Set to broken strate and Create area 2D to hold that state when the player is inside. 
	set_cell(0, coord, 0, Vector2i(4,0))
	var area := _create_area(coord, AREA)
	
	# Waiting Timer
	await(get_tree().create_timer(respawn_timer).timeout)

	# Repawn procedure. If the player is still inside the tile, hold it until he leaves the area2D.
	if not respawn_tile[coord]:
		await(area.body_exited)
	set_cell(0, coord, 0, Vector2i(0,0))

	# Delete objects and reset some variables
	area.queue_free()
	sprite.queue_free()
	breaking_tile[coord] = false

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
				respawn_tile[coord] = false
			)
		area.connect("body_exited", func(body): 
			if body.name == "Player":
				respawn_tile[coord] = true
			)
	elif area_enum == DISAREA:
		area = disarea_preload.instantiate()
		area.connect("body_entered", func(body):
			var coord_new := local_to_map(area.global_position + Vector2(1,0))
			if body.name == "Player":
				break_platform(coord_new)
			)
	area.global_position = map_to_local(coord)
	add_child(area)
	return area
