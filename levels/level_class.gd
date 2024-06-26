extends Node
class_name Level ## The class for all levels

## The name of the level. It will be displayed at the bottom of the viewport.
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
	var current_level = get_number()
	$LevelName.set_level_name(level_name)

	Global.current_level = get_number()
	Global.current = level_name
	Global.hardest_check()
	Global.save_game() # this will save the game on every level change or restart

	if Global.is_level_notification_appear and current_level < 31:
		$LevelNotification.refresh_text()
		$LevelNotification.appear()
		Global.is_level_notification_appear = false

	# Music
	if current_level >= 0 and current_level < 21:
		Audio.music_play("Music120")
	elif current_level >= 21 and current_level < 30:
		Audio.music_play("Music2130")
	else:
		Audio.music_pause()
	
	# Transition
	if Global.is_starting_new_game:
		$LevelTransition.play()
		Global.is_starting_new_game = false
		$LevelNotification.set_timer(2.4)
	else:
		$LevelTransition.hide_transition()

func _input(event):
	if event.is_action_pressed("pause") and $LevelTransition.is_playing():
		$LevelNotification.set_timer(1)
		$LevelTransition.hide_transition()

func _on_kill_zone_body_entered(body:Node2D):
	if body.name == "Player":
		body.die(true)

func _on_win_zone_body_entered(body:Node2D):
	if body.name == "Player":
		Audio.play("Start")
		Global.is_level_notification_appear = true
		Global.current_death = 0
		get_tree().change_scene_to_file(next_level())
