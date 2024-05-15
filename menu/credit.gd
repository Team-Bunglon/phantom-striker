extends Control
class_name Credit

# Array to store references to the VBoxContainers
@onready var vbox_containers = [
	$Credit1,
	$Credit2,
	$Credit3,
	$Credit4,
	$Credit5
]
@onready var input_timer = $Timer
# Index of the currently visible VBoxContainer
var current_vbox_index = 0
var onLastIndex = false

func _ready():
	# Initially, enable the first VBoxContainer
	vbox_containers[current_vbox_index].visible = true
	$"Stats/HBoxContainer4/TotalTime".text = str(GameStopwatch.get_elapsed_time_in_seconds())
	$"Stats/HBoxContainer5/TotalCollectibles".text = str(Global.collectibles)
	$"Stats/HBoxContainer6/TotalDeaths".text = str(Global.death_count)

func _input(event):
	if event.is_action_pressed("ui_accept") and not onLastIndex and input_timer.is_stopped():
		cycle_vbox_containers()
		input_timer.start(1.0)
		
func cycle_vbox_containers():
	# Disable the currently visible VBoxContainer
	vbox_containers[current_vbox_index].visible = false

	# Move to the next VBoxContainer index
	current_vbox_index = current_vbox_index + 1
	
	if current_vbox_index == 4:
		onLastIndex = true
	# Enable the new VBoxContainer
	vbox_containers[current_vbox_index].visible = true
