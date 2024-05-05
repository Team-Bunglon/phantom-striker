extends Node2D
class_name AudioGlobal

func play(audio_name: String):
	get_node(audio_name).playing = true
