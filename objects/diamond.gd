extends StaticBody2D
class_name Diamond

func _ready():
	$AnimationPlayer.play("idle")

func struck():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("struck")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "struck":
		$AnimationPlayer.play("idle")

