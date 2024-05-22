extends Control
class_name CreditText

var is_fading: bool = false

func _ready():
	var pick: int = randi() % 4
	match pick:
		0:
			$BackgroundRoot.visible = true
			$BackgroundTrunk.visible = false
			$BackgroundBranch.visible = false 
			$BackgroundFruit.visible = false
		1:
			$BackgroundRoot.visible = false
			$BackgroundTrunk.visible = true
			$BackgroundBranch.visible = false 
			$BackgroundFruit.visible = false
		2:
			$BackgroundRoot.visible = false
			$BackgroundTrunk.visible = false
			$BackgroundBranch.visible = true
			$BackgroundFruit.visible = false
		3:
			$BackgroundRoot.visible = false
			$BackgroundTrunk.visible = false
			$BackgroundBranch.visible = false 
			$BackgroundFruit.visible = true

	$AnimationPlayer.play("scroll")

func _input(event):
	if is_fading:
		return
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.speed_scale = 6
	elif event.is_action_released("ui_accept"):
		$AnimationPlayer.speed_scale = 1
	

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "scroll":
		is_fading = true
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play("fade_out")
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file("res://menu/main_screen.tscn")

