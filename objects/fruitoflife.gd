extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
 		#GameStopwatch.pause = true
		Global.has_started_game = false
		Global.game_running = false
