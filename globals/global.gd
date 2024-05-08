extends Node

@export var save_location: String = "user://save.json"

# Booleans when the game process is running
var has_applied_setting_on_launch: bool = false
var game_running: bool = false
var is_paused: bool = false

# Countables
var death_count: int = 0:
	set(value):
		death_count = value
		print("ded " + str(death_count))
		save_game()
var collectibles: int = 0:
	set(value):
		collectibles = value
		print("collect " + str(collectibles))
		save_game()
var collected: Array = []

# Saveable variable maybe??????
var music_vol: int = 5:
	set(value):
		music_vol = value
		save_game()
var sound_vol: int = 5:
	set(value):
		sound_vol = value
		save_game()
var gamespeed: int = 100:
	set(value):
		gamespeed = value
		save_game()
var current_scaling: int = 1:
	set(value):
		current_scaling = value
		save_game()
var maximum_scaling: int = 0:
	set(value):
		maximum_scaling = value
		save_game()
var fullscreen: String = "No":
	set(value):
		fullscreen = value
		save_game()

# Some function
func reset_global_value():
	death_count = 0
	collectibles = 0
	GameStopwatch.reset()

func _ready():
	load_game()

func save_game():
	var save: Save = Save.new()

	save.settings = {
		"music_vol": music_vol,
		"sound_vol": sound_vol,
		"gamespeed": gamespeed,
		"current_scaling": current_scaling,
		"maximum_scaling": maximum_scaling,
		"fullscreen": fullscreen
	}

	save.countables = {
		"death_count": death_count,
		"collectibles": collectibles,
		"collected": collected
	}
	
	save_file(save)

func load_game():
	var save: Save
	if save_exists():
		save = load_file()
	else:
		return
	
	music_vol = save.settings.get("music_vol", 5)
	sound_vol = save.settings.get("sound_vol", 5)
	gamespeed = save.settings.get("gamespeed", 100)
	current_scaling = save.settings.get("current_scaling", 1)
	maximum_scaling = save.settings.get("maximum_scaling", 0)
	fullscreen = save.settings.get("fullscreen", "No")
	
	death_count = save.countables.get("death_count", 0)
	collectibles = save.countables.get("collectibles", 0)
	collected = save.countables.get("collected", [])

func save_exists():
	return FileAccess.file_exists(save_location)

func save_file(save: Save):
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	
	var data := {
		"settings": save.settings,
		"countables": save.countables
	}
	
	file.store_string(JSON.stringify(data))
	file.close()

func load_file():
	var file = FileAccess.open(save_location, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data: Dictionary = JSON.parse_string(content)
	var save = Save.new()
	save.settings = data.get("settings")
	save.countables = data.get("countables")
	
	return save
