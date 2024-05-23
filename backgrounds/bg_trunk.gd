extends BackgroundImage
class_name BackgroundTrunk

enum POS {
	## For Level 12-19.
	MID = 0,
	## For Level 11 (start of the trunk section).
	TOP = 1,
	## For Level 20 (end of the trunk section). 
	BOTTOM = 2,
	## For the fruit of life room.
	FRUIT = 3,
}

@export var trunk_background: POS		 ## The background of the trunk
@export var scroll_factor: int = 0		 ## Scroll the BackgroundMain (the hill image) to bottom by 8 pixels per [param scroll_factor]
@export var cloud_move_step: float = 0.5 ## How fast the cloud would scroll per frame.

@onready var cloud: Sprite2D = %BackgroundCloud
static var cloud_posx: float = 1280.0

func _ready():
	_set_trunk_bg(trunk_background)
	cloud.position.x = cloud_posx
	$BackgroundMain.global_position.y += 8 * scroll_factor
	$BackgroundSky.global_position.y += 8 * scroll_factor

# We have to move the cloud by code.
# the reason is that animation player will make
# the cloud "flicker" every time the scene is restarted.
func _physics_process(_delta):
	cloud.position.x -= cloud_move_step
	if cloud.position.x <= -640.0:
		cloud.position.x = 1280.0
	cloud_posx = cloud.position.x

func _set_trunk_bg(val: int):
	var bool_arr: Array[bool] = []
	bool_arr.resize(len(POS))
	bool_arr.fill(false)
	bool_arr[val] = true

	$BackgroundMid.visible = bool_arr[0]
	$BackgroundTop.visible = bool_arr[1]
	$BackgroundBottom.visible = bool_arr[2]
	$BackgroundFruit.visible = bool_arr[3]
