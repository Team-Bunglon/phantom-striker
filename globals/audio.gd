extends Node2D
class_name AudioGlobal

@onready var music_current: String = "None"
@onready var default_db: Dictionary = {}

func play(audio_name: String):
	get_node(audio_name).playing = true

## Use this to change to other music as well.
func music_play(music_name: String):
	var music_node := get_node(music_name)

	if not default_db.has(music_name):
		default_db[music_name] = music_node.volume_db

	if music_current != "None":
		var music_node_prev := get_node(music_current)
		music_node_prev.playing = false

	music_current = music_name
	music_node.playing = true
	print(music_current)


