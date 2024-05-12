extends TileMap

@export var respawn_timer: float = 5.0	## The time it takes for the tile to respawn after being destroyed.
@onready var area_preload: Resource = preload("res://objects/tilearea.tscn")
@onready var respawn_tile: Dictionary = {}

## Function to change the tile atlas to a broken state
func break_platform(coord):
	# Change the tile sprite
	set_cell(0, coord, 0, Vector2i(1,0))

	# Create an area2D
	var area: Area2D = area_preload.instantiate()
	area.global_position = map_to_local(coord)
	add_child(area)

	# Connect its signal to detect if the player is inside the tile
	respawn_tile[coord] = true
	area.connect("body_entered", func(body): 
		if body.name == "Player":
			respawn_tile[coord] = false
		)
	area.connect("body_exited", func(body): 
		if body.name == "Player":
			respawn_tile[coord] = true
		)

	# Waiting Timer
	await(get_tree().create_timer(respawn_timer).timeout)

	# Repawn procedure. If the player is still inside the tile, hold it until he leaves the area2D.
	if not respawn_tile[coord]:
		await(area.body_exited)
	set_cell(0, coord, 0, Vector2i(0,0))
	area.queue_free()
