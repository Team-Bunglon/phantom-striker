extends Node2D
class_name GateKey

@export var gate_map_object: NodePath	## The GateMap node. You have to assign every GateKey in your level with a GateMap.
@export var rotation_value: float = 0.15
@onready var gate_map_node: GateMap

var is_collected = false

func _ready():
	$AnimationPlayer.play("idle")
	if gate_map_object.is_empty():
		assert(false, "Please assign every gate key with a gate map")
	gate_map_node = get_node(gate_map_object)

func _physics_process(_delta):
	if is_collected:
		$Sprite2D.rotate(rotation_value)

func _on_key_area_body_entered(body:Node2D):
	if body.name == "Player" and not is_collected:
		Audio.play("Key")
		is_collected = true
		$AnimationPlayer.play("obtained")
		$KeyArea.disconnect("body_entered", _on_key_area_body_entered)
		gate_map_node.unlock()

