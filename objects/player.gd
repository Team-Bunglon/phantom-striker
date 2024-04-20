extends CharacterBody2D
class_name Player

## The speed of the character moving on either X axis
@export var speed: float = 300.0

## The maximum jump height the character can reach
@export var jump_height: float = 400.0

## The time it takes for the character to reach jump_height
## as long as the player keeps holding the jump button.
## The jump gravity will be calculated using this value.
@export var jump_time_to_peak: float

## The time it take for the character to descend from jump_height
## to the ground the player performs a jump on previously.
## The fall gravity will be calculated using this value.
@export var jump_time_to_descend: float

## The delay in frame before the character reacts to the input.
## This is to prevent diagonal input not being registered correctly due to a 
## possible slight delay between pressing two different keys at the same time.
@export var max_input_frame_delay: int = 1

# Prepare fixed variables on ready
@onready var state: Variant = $AnimationTree.get("parameters/playback")
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity: float = ((2.0 * jump_height) / (jump_time_to_peak ** 2))
@onready var fall_gravity: float = ((2.0 * jump_height) / (jump_time_to_descend ** 2))

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_strike_delay: bool = false
var input_frame_delay: int = max_input_frame_delay

# Constants
var strike_dir= {
	Vector2(1,0): ["strike_right", "RayCastR"],
	Vector2(-1,0): ["strike_left", "RayCastL"],
	Vector2(0,1): ["strike_up", "RayCastU"],
	Vector2(0,-1): ["strike_down", "RayCastD"],
	Vector2(-1,1): ["strike_up_left", "RayCastUL"],
	Vector2(1,1): ["strike_up_right", "RayCastUR"],
	Vector2(1,-1): ["strike_down_right", "RayCastDR"],
	Vector2(-1,-1): ["strike_down_left", "RayCastDL"],
	}

func move():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity 

func jump(delta):
	velocity.y += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y += fall_gravity * delta * 4

func strike():
	var direction_x = Input.get_axis("strike_left", "strike_right")	  # Left is -1, right is +1
	var direction_y = Input.get_axis("strike_up", "strike_down") * -1 # Down is -1, up is +1
	var direction_xy = Vector2(direction_x, direction_y)
	if not on_strike_delay and direction_xy != Vector2.ZERO:
		if input_frame_delay > 0:
			input_frame_delay -= 1
		else:
			print(strike_dir[direction_xy])
			state.travel(strike_dir[direction_xy][0])
			strike_response(direction_xy, get_node(strike_dir[direction_xy][1]))
			input_frame_delay = max_input_frame_delay
			direction_xy = Vector2.ZERO
			on_strike_delay = true
			$StrikeDelay.start()

func strike_response(direction: Vector2, raycast: RayCast2D):
	print(raycast.name)
	print(raycast.is_colliding())
	if raycast.is_colliding():
		print(raycast.get_collider().name)
		if raycast.get_collider().name == "TileMap":
			velocity.x = -direction.x * speed
			velocity.y = jump_velocity * direction.y

func _ready():
	state.travel("idle")

func _physics_process(delta):
	jump(delta)
	move()
	strike()
	move_and_slide()

func _on_strike_delay_timeout():
	on_strike_delay = false
