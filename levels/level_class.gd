extends Node
class_name Level

@export var room_name: String = "Sample Room Name"

func next_level():
	if "#" in name:
		return "res://levels/level" + str(int(name.get_slice("#",1))+1) + ".tscn"
	else:
		assert(false, name + ": The name of the root node of this level must be 'level#[int]'")

func _ready():
	print(name + ": " + room_name)
	$Canvas/RoomName.text = room_name

func _on_kill_zone_body_entered(body:Node2D):
	if body.name == "Player":
		get_tree().reload_current_scene()

func _on_win_zone_body_entered(body:Node2D):
	if body.name == "Player":
		get_tree().change_scene_to_file(next_level())
