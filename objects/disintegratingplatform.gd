extends StaticBody2D

var time = 1

func _ready():
	set_process(false)

func _process(delta):
	time += 1
	$AnimatedSprite.play()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		set_process(true)
		$Timer.start(1)

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Timer.stop()
		$AnimatedSprite.stop()
		set_process(false)

func _on_timer_timeout():
	#queue_free()
	$AnimatedSprite.visible = false
	$CollisionShape2D.disabled = true
	$RespawnTimer.start(5)

func _on_respawn_timer_timeout():
	$AnimatedSprite.visible = true
	$CollisionShape2D.disabled = false
