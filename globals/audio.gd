extends Node
class_name AudioGlobal

## The duration of which the music would cross fade
@export var fade_duration: float = 2.0

# These two variables should be null on start
@onready var music_node: AudioStreamPlayer
@onready var music_prev: AudioStreamPlayer
@onready var default_db: Dictionary = {}

## Play a sound effect. Do NOT play music using this, use music_play().
func play(audio_name: String):
	get_node(audio_name).playing = true

## Use this to play music as well as changing to other music.
func music_play(music_name: String, is_fading = true):
	var fade_out_tween := create_tween()
	var fade_in_tween := create_tween()
	fade_out_tween.finished.connect(_on_music_faded)

	# During the start of the game when the first music is played
	if music_node == null:
		music_node = _get_music(music_name)
		music_node.playing = true

	# During mid game when music is changed
	elif music_node != null:
		music_prev = music_node
		music_node = _get_music(music_name)
		if is_fading:
			music_node.volume_db = -INF
			music_node.playing = true
			fade_out_tween.tween_method(_change_music_prev_volume, 1.0, 0.0, fade_duration)
			fade_in_tween.tween_method(_change_music_node_volume, 0.0, 1.0, fade_duration)
		else:
			music_node.volume_db = default_db[music_node.name]
			music_node.playing = true
			music_prev.playing = false

## If you need to get the currently playing music for some reason, use this.
func get_currently_playing_music():
	return music_node

func _change_music_node_volume(value: float):
	music_node.volume_db = linear_to_db(value) + default_db[music_node.name]

func _change_music_prev_volume(value: float):
	music_prev.volume_db = linear_to_db(value) + default_db[music_prev.name]

func _get_music(music_name: String) -> AudioStreamPlayer:
	var new_music_node := get_node(music_name)
	if not default_db.has(music_name):
		default_db[music_name] = new_music_node.volume_db
	return new_music_node

func _on_music_faded():
	music_prev.playing = false

