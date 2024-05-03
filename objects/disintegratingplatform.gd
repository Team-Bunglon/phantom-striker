extends StaticBody2D

func _ready():
	set_process(false)

func _process(delta):
	$AnimationPlayer.play("disintegrate")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		set_process(true)
		$Timer.start(1)

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Timer.stop()
		$AnimationPlayer.stop()
		set_process(false)

func _on_timer_timeout():
	#queue_free()
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$LastFrame.visible = true
	$RespawnTimer.start(5)

func _on_respawn_timer_timeout():
	$CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	$LastFrame.visible = false
