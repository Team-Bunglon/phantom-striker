extends StaticBody2D
class_name Diamond

@export var white: bool = false ## Is this a white diamond?
var color: String

func _ready():
	$AnimationPlayer.play("idle")
	color = "DiamondWhite" if white else "DiamondBlack"

func struck():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("struck")
	Audio.play(color)

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "struck":
		$AnimationPlayer.play("idle")

