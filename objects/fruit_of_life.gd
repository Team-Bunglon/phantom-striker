extends Area2D
class_name FruitOfLife

## Emitted when the player touches the fruit. You win the game! Congrats.
signal you_win()

## Emitted when the win timer finishes after the player touches the fruit.
signal finished_win()

func _ready():
	$AnimationPlayer.play("idle")

func _on_body_entered(body):
	if body.name == "Player":
		GameStopwatch.paused = true
		Global.game_running = false

		Audio.play("Win")
		$AnimationPlayer.play("win")

		emit_signal("you_win")
		$WinTimer.start()
	
func _on_win_timer_timeout():
	emit_signal("finished_win")
