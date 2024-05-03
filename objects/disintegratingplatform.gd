extends StaticBody2D

var isTouched = false

func _ready():
	set_process(false)

func _process(delta):
	$AnimationPlayer.play("disintegrate")

func _on_area_2d_body_entered(body):
	# first time entry
	print($Timer.get_time_left())
	print(isTouched)
	if body.name == "Player" and isTouched == false: 
		set_process(true)
		$Timer.start(1)
	if body.name == "Player" and isTouched:
		set_process(true)
		$Timer.start($Timer.get_time_left())

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		isTouched = true
		$RespawnTimer.start(5)
		$Timer.set_paused(true)
		$AnimationPlayer.pause()
		set_process(false)

func _on_timer_timeout():
	#queue_free()
	isTouched = false
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$LastFrame.visible = true
	$RespawnTimer.start(5)

func _on_respawn_timer_timeout():
	isTouched = false
	$CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	$LastFrame.visible = false
