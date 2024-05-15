extends Node
class_name Level

@export var level_name: String = "Sample Room Name"

func next_level() -> String:
	var next_level_number: String = str(get_number() + 1)
	return "res://levels/level" + next_level_number + ".tscn"

func get_number() -> int:
	if "#" in name:
		return int(name.get_slice("#",1))
	else:
		return name.to_int()

func _ready():
	$LevelName.set_level_name(level_name)
	Global.current_level = get_number()
	Global.save_game() # this will save the game on every level change or restart
	# Music
	var current_level = get_number()
	if current_level >= 0 and current_level < 21:
		Audio.music_play("Music120")
	else:
		Audio.music_play("Music2130")

func _on_kill_zone_body_entered(body:Node2D):
	if body.name == "Player":
		body.die(true)

func _on_win_zone_body_entered(body:Node2D):
	if body.name == "Player":
		Audio.play("Start")
		get_tree().change_scene_to_file(next_level())
