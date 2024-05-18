extends TileMap
class_name DestroyablePlatform

@export var respawn_timer: float = 5.0 ## The time it takes for the tile to respawn after being destroyed.
@export var spike_object: NodePath	   ## The spike object this platform should associate. If there's a spike inside this object, it'll turn white.
@export var red_spike_object: NodePath ## The red spike object this platform should associate. If there's a red spike inside this object, it'll turn red.
@onready var area_preload: Resource = preload("res://objects/tile_area.tscn")
@onready var disintegrating_particle_preload: Resource = preload("res://objects/disintegrating.tscn")

var spike_node: TileMap
var red_spike_node: TileMap

var tiles_check: Dictionary = {} ## Check if the tile is already be checked during the cluster calculation.
var tiles_orig: Dictionary = {}  ## The sprite of the tile before being destroyed.
var tiles_area: Dictionary = {}  ## The Area2D of the tile during the broken state.

var cluster: Array[Vector2i]
var cluster_entered: Dictionary = {}
var cluster_tiles_entered: Dictionary = {}

## Respawn the tiles inside a cluster. Emitted the player leaves the cluster's Area2D group.
signal perform_respawn()

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
	if not cluster.is_empty(): # Check if a cluster is formed. Should only be run in one frame.
		var cluster_temp := cluster
		cluster = []
		_break_cluster(cluster_temp)

## The function to be called when being struck by the player. [br]
## It will form a cluster of destroyable platforms by 
## checking its neighbors and perform recursion.
## A cluster must be formed within a single frame. 
func break_platform(coord: Vector2i):
	tiles_check[coord] = true
	cluster.append(coord)
	for g in get_surrounding_cells(coord):
		if get_cell_source_id(0, g) != -1:
			if tiles_check.has(g):
				if tiles_check[g] == false:
					break_platform(g)
			else:
				break_platform(g)

## Break the cluster
func _break_cluster(cluster_array: Array[Vector2i]):
	cluster_entered[cluster_array] = false
	cluster_tiles_entered[cluster_array] = {}

	# Break tiles in a cluster
	for c in cluster_array:
		tiles_check[c] = false
		_break_platform_procedure(c, cluster_array)

	# Create timer and wait for respawn
	await(get_tree().create_timer(respawn_timer, false).timeout)
	if cluster_entered[cluster_array]:
		await(self.perform_respawn)

	# Respawn tiles in a cluster
	for c in cluster_array:
		_respawn_platform_procedure(c)

## Function to change the tile atlas to a broken state
func _break_platform_procedure(coord: Vector2i, cluster_array: Array[Vector2i]):
	cluster_tiles_entered[cluster_array][coord] = false
	if not tiles_orig.has(coord):
		tiles_orig[coord] = Vector2i(0,0)

	# Set to broken state and Create area 2D to hold that state when the player is inside. 
	Audio.play("Destroy")
	set_cell(0, coord, 0, Vector2i(3,0))
	_disintegrating_particle_create(coord)
	tiles_area[coord] = _create_area(coord, cluster_array)

## Respawn every platform inside a cluster
func _respawn_platform_procedure(coord: Vector2i):
	set_cell(0, coord, 0, tiles_orig[coord]) # Repawn procedure. If the player is still inside the tile, hold it until he leaves the area2D.
	tiles_area[coord].queue_free()			 # Delete objects and reset some variables

## Particle stuff
func _disintegrating_particle_create(coord: Vector2i):
	var disintegrating_particle: Disintegrating = disintegrating_particle_preload.instantiate()
	var pos: Vector2 = coord * 16 + Vector2i(8, 8)
	disintegrating_particle.emitting(pos)
	get_parent().add_child(disintegrating_particle)

## Factory function to create the area after the platform is destroyed.
func _create_area(coord: Vector2i, cluster_array: Array[Vector2i]) -> Area2D:
	var area: Area2D = area_preload.instantiate()
	area.connect("body_entered", func(body): 
		if body.name == "Player":
			cluster_tiles_entered[cluster_array][coord] = true
			cluster_entered[cluster_array] = true
		)
	area.connect("body_exited", func(body): 
		if body.name == "Player":
			cluster_tiles_entered[cluster_array][coord] = false
			if not cluster_tiles_entered[cluster_array].values().has(true):
				cluster_entered[cluster_array] = false
				emit_signal("perform_respawn")
		)
	area.global_position = map_to_local(coord)
	add_child(area)
	return area
