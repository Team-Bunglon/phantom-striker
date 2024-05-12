extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(GameStopwatch.get_elapsed_time_in_seconds())

