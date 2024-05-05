extends TileMap



# Function to change the tile texture
func break_platform(coord):
	print("Break platform!")
	set_cell(0, coord, 0, Vector2i(1,0))
	await(get_tree().create_timer(2.0).timeout)
	print("Platform regenerated")
	set_cell(0, coord, 0, Vector2i(0,0))
	



