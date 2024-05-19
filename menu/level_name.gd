extends CanvasLayer
class_name LevelName ## A canvas layer used to show the level name

func set_level_name(level_name: String):
	$LevelNameLabel.text = level_name 

func _on_move_camera_area_2_area_entered(area:Area2D):
	if area.name == "PlayerPoint":
		$LevelNameLabel.text = "Desolation Room"

