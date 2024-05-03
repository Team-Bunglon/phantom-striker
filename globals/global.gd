extends Node

# Booleans when the game process is running
var has_applied_setting_on_launch: bool = false
var game_running: bool = false
var is_paused: bool = false

# Countables
var death_count: int = 0
var collectibles: int = 0

# Saveable variable maybe??????
var music_vol: int = 5
var sound_vol: int = 5
var gamespeed: int = 100
var current_scaling: int = 1
var maximum_scaling: int = 0
var fullscreen: String = "No"

# Some function
func reset_global_value():
	death_count = 0
	collectibles = 0
	GameStopwatch.reset()
