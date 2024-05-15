extends TileMap
class_name DestroyablePlatform

@export var respawn_timer: float = 5.0	## The time it takes for the tile to respawn after being destroyed.
@onready var area_preload: Resource = preload("res://objects/tile_area.tscn")

var respawn_tile: Dictionary = {}

## Function to change the tile atlas to a broken state
func break_platform(coord):
	# Set some variables
	respawn_tile[coord] = true

	# Set to broken strate and Create area 2D to hold that state when the player is inside. 
	Audio.play("Destroy")
	set_cell(0, coord, 0, Vector2i(1,0))
	var area := _create_area(coord)

	# Waiting Timer
	await(get_tree().create_timer(respawn_timer, false).timeout)

	# Repawn procedure. If the player is still inside the tile, hold it until he leaves the area2D.
	if not respawn_tile[coord]:
		await(area.body_exited)
	set_cell(0, coord, 0, Vector2i(0,0))

	# Delete objects and reset some variables
	area.queue_free()
	print(respawn_tile[coord])

func _create_area(coord) -> Area2D:
	var area: Area2D = area_preload.instantiate()
	area.connect("body_entered", func(body): 
		if body.name == "Player":
			respawn_tile[coord] = false
		)
	area.connect("body_exited", func(body): 
		if body.name == "Player":
			respawn_tile[coord] = true
		)
	area.global_position = map_to_local(coord)
	add_child(area)
	return area
