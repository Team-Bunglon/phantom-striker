extends TileMap
class_name DestroyablePlatform

@export var respawn_timer: float = 5.0 ## The time it takes for the tile to respawn after being destroyed.
@export var spike_object: NodePath	   ## The spike object this platform should associate. If there's a spike inside this object, it'll turn white.
@export var red_spike_object: NodePath ## The red spike object this platform should associate. If there's a red spike inside this object, it'll turn red.
@onready var area_preload: Resource = preload("res://objects/tile_area.tscn")
@onready var disintegrating_particle_preload: Resource = preload("res://objects/disintegrating.tscn")

var spike_node: TileMap
var red_spike_node: TileMap

var tiles_check: Dictionary = {} ## Check if the tile is already be checked during the cluster calculation
var tiles_orig: Dictionary = {}
var area_tile: Dictionary = {}

var cluster: Array[Vector2i]
var cluster_respawn: Dictionary = {}
var cluster_tiles_entered: Dictionary = {}

signal test()

func _ready():
	if global_position != Vector2.ZERO:
		assert(false, "DestroyablePlatform should have (0,0) as its position")
	spike_node = get_node_or_null(spike_object)
	red_spike_node = get_node_or_null(red_spike_object)
	if not spike_object.is_empty():
		for s in spike_node.get_used_cells(0):
			if get_cell_source_id(0, s) != -1:
				tiles_orig[s] = Vector2i(1,0)
				set_cell(0, s, 0, tiles_orig[s])
	if not red_spike_object.is_empty():
		for s in red_spike_node.get_used_cells(0):
			if get_cell_source_id(0, s) != -1:
				tiles_orig[s] = Vector2i(2,0)
				set_cell(0, s, 0, tiles_orig[s])

func _physics_process(_delta):
	if not cluster.is_empty(): # Check if a cluster is formed
		_break_cluster(cluster)
		cluster = []

## The function to be called when being struck by the player. [br]
## It will form a cluster of destroyable platforms by 
## checking its neighbors and function recursion.
## A cluster must be formed in a single frame. 
func break_platform(coord):
	tiles_check[coord] = true
	cluster.append(coord)
	for g in get_surrounding_cells(coord):
		if get_cell_source_id(0, g) != -1 or get_cell_source_id(1, g) != -1:
			if tiles_check.has(g):
				if tiles_check[g] == false:
					break_platform(g)
			else:
				break_platform(g)

## Break the cluster
func _break_cluster(cluster_array):
	cluster_respawn[cluster_array] = true
	cluster_tiles_entered[cluster_array] = {}
	for c in cluster_array:
		tiles_check[c] = false
		_break_platform_procedure(c, cluster_array)
	await(get_tree().create_timer(respawn_timer, false).timeout)
	if not cluster_respawn[cluster_array]:
		await(self.test)
	for c in cluster_array:
		_respawn_platform_procedure(c)

## Function to change the tile atlas to a broken state
func _break_platform_procedure(coord, cluster_array):
	# Set some variables
	cluster_tiles_entered[cluster_array][coord] = false
	if not tiles_orig.has(coord):
		tiles_orig[coord] = Vector2i(0,0)

	# Set to broken state and Create area 2D to hold that state when the player is inside. 
	Audio.play("Destroy")
	_disintegrating_particle_create(coord)
	set_cell(0, coord, 0, Vector2i(3,0))
	area_tile[coord] = _create_area(coord, cluster_array)

func _respawn_platform_procedure(coord):
	set_cell(0, coord, 0, tiles_orig[coord]) # Repawn procedure. If the player is still inside the tile, hold it until he leaves the area2D.
	area_tile[coord].queue_free() # Delete objects and reset some variables

func _disintegrating_particle_create(coord: Vector2i):
	var disintegrating_particle: Disintegrating = disintegrating_particle_preload.instantiate()
	var pos: Vector2 = coord * 16 + Vector2i(8, 8)
	disintegrating_particle.emitting(pos)
	print("destroyed at "+ str(coord))
	get_parent().add_child(disintegrating_particle)

func _create_area(coord, cluster_array) -> Area2D:
	var area: Area2D = area_preload.instantiate()
	area.connect("body_entered", func(body): 
		if body.name == "Player":
			cluster_tiles_entered[cluster_array][coord] = true
			cluster_respawn[cluster_array] = false
		)
	area.connect("body_exited", func(body): 
		if body.name == "Player":
			cluster_tiles_entered[cluster_array][coord] = false
			if not cluster_tiles_entered[cluster_array].values().has(true):
				cluster_respawn[cluster_array] = true
				emit_signal("test")
		)
	area.global_position = map_to_local(coord)
	add_child(area)
	return area
