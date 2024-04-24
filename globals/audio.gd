extends Node2D

func play(audio_name: String):
	get_node(audio_name).playing = true
