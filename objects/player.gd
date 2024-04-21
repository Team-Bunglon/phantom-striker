extends CharacterBody2D
class_name Player

## The max_speed of the character when moving on either X axis.
@export var max_speed: float = 300.0

@export var acceleration: float = 100.0

@export var friction: float = 120.0

## The horizontal launch max_speed whenever the character has done a successful striking.
## We may need vertical launch max_speed as well. 
@export var max_launch: float = 600.0

## The multiplier of which the player will lose their launch momentum.
## The launch max_speed will be lost by delta * launch_lost_multiplier until it reaches 0.
@export var launch_decelerate: float = 8.0

## The maximum jump height the character can reach.
@export var jump_height: float = 400.0

## The time (in seconds) it takes for the character to reach jump_height
## as long as the player keeps holding the jump button.
## The jump gravity will be calculated using this value.
@export var jump_time_to_peak: float = 0.5

## The time it take for the character to descend from jump_height
## to the ground the player performs a jump on previously.
## The fall gravity will be calculated using this value.
@export var jump_time_to_descend: float = 0.4

## The amount of frame (in 60FPS) that allows the character to still jump after leaving the floor.
## This is done to make jumping feels more forgiving after falling off the ledge.
@export var max_coyote_frame: int =  10

## The amount of frame (in 60FPS) that, if the player presses the jump button before hitting the floor,
## the character will jump as soon as he touches the floor.
@export var max_jump_buffer_frame: int = 8

## The delay in frame (in 60FPS) before the character reacts to the input.
## This is to prevent diagonal input not being registered correctly due to a 
## possible slight delay between pressing two different keys at the same time.
@export var max_input_delay_frame: int = 1

# Prepare fixed variables on ready
@onready var state: Variant = $AnimationTree.get("parameters/playback")
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity: float = ((2.0 * jump_height) / (jump_time_to_peak ** 2))
@onready var fall_gravity: float = ((2.0 * jump_height) / (jump_time_to_descend ** 2))

# Changing Variables
var launch: float = 0.0
var launch_direction: float = 1.0
var on_strike_delay: bool = false
var can_strike: bool = true
var input_delay_frame: int = max_input_delay_frame
var coyote_frame: int = max_coyote_frame
var jump_buffer_frame: int = 0

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
	print(velocity.x)
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction)
		else:
			velocity.x = move_toward(velocity.x, 0, launch_decelerate)

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity 

func jump(delta):
	velocity.y += get_gravity() * delta
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_frame > 0:
			jump_procedure()
		elif not is_on_floor():
			jump_buffer_frame = max_jump_buffer_frame
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y += fall_gravity * delta * 4

func jump_procedure():
	velocity.y = -jump_velocity
	coyote_frame = 0
	jump_buffer_frame = 0

func strike():
	var direction_x = Input.get_axis("strike_left", "strike_right")	  # Left is -1, right is +1
	var direction_y = Input.get_axis("strike_up", "strike_down") * -1 # Down is -1, up is +1
	var direction_xy = Vector2(direction_x, direction_y)
	if not on_strike_delay and can_strike and direction_xy != Vector2.ZERO:
		if input_delay_frame > 0:
			input_delay_frame -= 1
		else:
			print(strike_dir[direction_xy])
			state.travel(strike_dir[direction_xy][0])
			strike_response(direction_xy, get_node(strike_dir[direction_xy][1]))
			input_delay_frame = max_input_delay_frame
			direction_xy = Vector2.ZERO
			on_strike_delay = true
			can_strike = false
			$StrikeDelayTimer.start()

func strike_response(direction: Vector2, raycast: RayCast2D):
	print(raycast.name)
	print(raycast.is_colliding())
	if raycast.is_colliding():
		print(raycast.get_collider().name)
		if raycast.get_collider().name == "TileMap":
			if direction.x != 0:
				if direction.y == 0:
					velocity.x = -direction.x * max_launch * 1.2
				else:
					velocity.x = -direction.x * max_launch
			if direction.y != 0:
				velocity.y = jump_velocity * direction.y
			launch_direction = -direction.x
			launch = max_launch

func strike_hold_input():
	if not can_strike:
		if not Input.is_action_pressed("strike_left") and \
			not Input.is_action_pressed("strike_right") and \
			not Input.is_action_pressed("strike_up") and \
			not Input.is_action_pressed("strike_down"):
			can_strike = true

func launch_lost():
	if launch > 0.0:
		if not is_on_floor():
			launch = move_toward(launch, 0, launch_decelerate)
		else:
			launch = move_toward(launch, 0, friction)

func jump_buffer_frame_countdown():
	print(jump_buffer_frame)
	if jump_buffer_frame > 0:
		jump_buffer_frame -= 1
		if is_on_floor() and jump_buffer_frame > 0:
			jump_procedure()

func coyote_frame_countdown():
	if is_on_floor():
		coyote_frame = max_coyote_frame
	else:
		if coyote_frame > 0:
			coyote_frame -= 1

func _ready():
	state.travel("idle")

func _physics_process(delta):
	coyote_frame_countdown()
	jump_buffer_frame_countdown()
	jump(delta)
	move()
	strike()
	strike_hold_input()
	#launch_lost()
	move_and_slide()

func _on_strike_delay_timer_timeout():
	on_strike_delay = false
