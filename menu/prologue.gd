extends Control
var current = "slide1"

func _ready():
	
	start_animation_loop()
	
func _process(delta):
	if Input.is_action_pressed("start_game"):
		get_tree().change_scene_to_file("res://levels/level1.tscn")

func start_animation_loop():
	await play_animation("slide")
	await play_animation("reset")
	start_animation_loop()
	
func play_animation(animation_name):
	$Timer.start()
	await $Timer.timeout
	$AnimationPlayer.play(animation_name)
	await $AnimationPlayer.animation_finished


	

