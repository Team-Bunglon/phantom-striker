extends StaticBody2D
class_name DisintegratingPlatform

@onready var state = $AnimationTree.get("parameters/playback")
var readyToRespawn: bool = false
var isPlayerInside: bool = false

func play_audio():
	Audio.play("Disintegrate")

func disintegrate():
	state.travel("broken")

func respawn():
	if readyToRespawn and not isPlayerInside:
		readyToRespawn = false
		state.travel("solid")

## The area2d that detect if the player steps on it
func _on_area_2d_body_entered(body):
	if body.name == "Player": 
		disintegrate()

func _on_animation_tree_animation_finished(anim_name:StringName):
	if anim_name == "disintegrate":
		$RespawnTimer.start()

func _on_respawn_timer_timeout():
	readyToRespawn = true
	respawn()

func _on_area_2d_sprite_body_entered(body:Node2D):
	if body.name == "Player":
		isPlayerInside = true

func _on_area_2d_sprite_body_exited(body:Node2D):
	if body.name == "Player":
		isPlayerInside = false
		respawn()

