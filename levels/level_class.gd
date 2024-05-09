extends Node
class_name Level

@export var room_name: String = "Sample Room Name"

func next_level():
	if "#" in name:
		var next_level_number: String = str(get_number() + 1)
		return "res://levels/level" + next_level_number + ".tscn"
	else:
		assert(false, name + ": The name of the root node of this level must be 'level#[int]'")

func get_number() -> int:
	return int(name.get_slice("#",1))

func _ready():
	print(name + ": " + room_name)
	$Canvas/RoomName.text = room_name
	Global.current_level = get_number()
	Global.save_game() # this will save the game on every level change or restart

func _on_kill_zone_body_entered(body:Node2D):
	if body.name == "Player":
		body.die(true)

func _on_win_zone_body_entered(body:Node2D):
	if body.name == "Player":
		Audio.play("Start")
		get_tree().change_scene_to_file(next_level())
