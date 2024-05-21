extends BackgroundImage
class_name BackgroundTrunk

@export var is_bottom: bool = false  ## Only for the first level of the trunk section (Level 11).
@export var is_top: bool	= false	 ## Only for the last level of the trunk section (Level 20).
@export var is_fruit: bool	= false  ## Only for the fruit of life room.
@export var scroll_factor: int = 0   ## Scroll the BackgroundMain (the hill image) to bottom by 8 pixels per [param scroll_factor]
@export var cloud_move_step: float = 0.5 ## How fast the cloud would scroll per frame.

@onready var cloud: Sprite2D = %BackgroundCloud
static var cloud_posx: float = 1280.0

func _ready():
	cloud.position.x = cloud_posx
	$BackgroundMain.global_position.y += 8 * scroll_factor
	$BackgroundSky.global_position.y += 8 * scroll_factor
	if is_bottom:
		$BackgroundBottom.visible = true
		$BackgroundSub.visible = false
		$BackgroundMain.visible = false
	elif is_top:
		$BackgroundTop.visible = true
		$BackgroundSub.visible = false
	elif is_fruit:
		$BackgroundSub.visible = false
		$BackgroundMain.visible = false
		$BackgroundFruit.visible = true
	super._ready()

func _physics_process(_delta):
	# We have to move the cloud by code.
	# the reason is that animation player will make
	# the cloud "flicker" every time the scene is restarted.
	cloud.position.x -= cloud_move_step
	if cloud.position.x <= -640.0:
		cloud.position.x = 1280.0
	cloud_posx = cloud.position.x
