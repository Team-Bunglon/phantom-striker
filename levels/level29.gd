extends Level

func _on_move_camera_area_2_area_entered(area:Area2D):
	if area.name == "PlayerPoint":
		$LevelName.set_level_name("Desolation Room")
		Audio.music_pause()
