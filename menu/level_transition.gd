extends CanvasLayer
class_name LevelTransistion

func _ready():
	if Global.is_starting_new_game:
		$Transition.visible = true
		visible = true
	else:
		$Transition.visible = false
		visible = false

func play():
	$AnimationPlayer.play("fade_in")

func hide_transition():
	$AnimationPlayer.stop()
	$Transition.visible = false
	visible = false

func is_playing():
	return $AnimationPlayer.is_playing()
