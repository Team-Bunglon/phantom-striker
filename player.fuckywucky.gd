extends CharacterBody2D
class_name FuckyPlayer

## The maximum speed of the character when moving on either X axis.
@export var max_speed: float = 300.0

## The acceleration when the character starts moving from idle state to max_speed.
@export var acceleration: float = 100.0

## The deceleration when the character stops moving from current velocity.x to idle state.
@export var friction: float = 120.0

## The maximum horizontal launch speed whenever the character has done a successful striking that contains any of the horizontal direction.
## This value alone is a scalar value. The direction will be automatically calculated during the strike function.
@export var max_launch_h: float = 600.0
var launch_h: float = 0.0
var launch_h_direction: float = 1.0

## The deceleration of which the player will lose their launch_h momentum in the air.
@export var air_friction: float = 8.0

## The maximum jump height the character can reach.
@export var max_jump_height: float = 400.0

## The time (in seconds) it takes for the character to reach max_jump_height
## as long as the player keeps holding the jump button.
## The jump gravity will be calculated using this value.
@export var jump_time_to_peak: float = 0.5
@onready var jump_velocity: float = ((2.0 * max_jump_height) / jump_time_to_peak)
@onready var jump_gravity: float = ((2.0 * max_jump_height) / (jump_time_to_peak ** 2))

## The time (in seconds) it take for the character to descend from max_jump_height
## towards the ground of which the player previously performs a jump on.
## The fall gravity will be calculated using this value.
@export var jump_time_to_descend: float = 0.4
@onready var fall_gravity: float = ((2.0 * max_jump_height) / (jump_time_to_descend ** 2))

## The value that is multiplied to velocity.y when the player stop holding the jump button 
## before the character has reaches max_jump_height. It should be less than 1.0
@export var jump_lost_multiplier: float = 0.5

## The amount of frame (in 60FPS) that allows the character to still jump after wallking off the floor edge.
## This is done to make jumping from the edge feels more forgiving.
@export var max_coyote_frame: int =  10
var coyote_frame: int = max_coyote_frame

## The amount of frame (in 60FPS) that applies when the player is approaching the floor from a jump. 
## If the player presses the jump button before hitting the floor,
## the character will jump as soon as he touches the floor.
@export var max_jump_buffer_frame: int = 8
var jump_buffer_frame: int = 0

## The delay in frame (in 60FPS) before the character reacts to the input.
## This is done to prevent diagonal input not being registered correctly due to a 
## possible slight delay between pressing two different keys at the same time.
## The delay for doing another strike is done with $StrikeDelayTimer node.
@export var max_input_delay_frame: int = 1
var input_delay_frame: int = max_input_delay_frame
var on_strike_delay: bool = false	# Boolean for $StrikeDelayTimer
var can_strike: bool = true			# Boolean to prevent the character from doing a continous striking when the strike input is being held.

## The delay in frame (in 60FPS) before the character can move again while launched.
## This is done to prevent miscalculation on speed when the player is launching while pressing the move button.
@export var max_launch_delay_frame: int = 1

# Prepare fixed variables on ready
@onready var state: Variant = $AnimationTree.get("parameters/playback")
@onready var strike_dir= {
	#Vector2(x,y):	["animation_name". "RayCast2D_name"],
	Vector2(1,0):	["strike_right", "RayCastR"],
	Vector2(-1,0):	["strike_left", "RayCastL"],
	Vector2(0,1):	["strike_up", "RayCastU"],
	Vector2(0,-1):	["strike_down", "RayCastD"],
	Vector2(-1,1):	["strike_up_left", "RayCastUL"],
	Vector2(1,1):	["strike_up_right", "RayCastUR"],
	Vector2(1,-1):	["strike_down_right", "RayCastDR"],
	Vector2(-1,-1): ["strike_down_left", "RayCastDL"],
	}

func move():
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		launch_h = move_toward(launch_h, 0, air_friction)
	else:
		launch_h = move_toward(launch_h, 0, air_friction*4)
	if direction:
		if launch_h > 0.0:
			# When being launched and the player is moving towards the launch direction,
			# he should be moving as fast as the max_launch_h
			if sign(direction) == sign(launch_h_direction):
				velocity.x = move_toward(velocity.x, direction * max_speed, acceleration/8)
			else:
				velocity.x = move_toward(velocity.x, direction * max_speed, acceleration/8)
		else:
			velocity.x = move_toward(velocity.x, direction * max_speed, acceleration)
	else:
		if launch_h > 0.0:
			velocity.x = launch_h * launch_h_direction
		else:
			velocity.x = move_toward(velocity.x, 0, friction)


func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity 

func jump(delta):
	velocity.y += get_gravity() * delta
	if is_on_floor():
		coyote_frame = max_coyote_frame
	else:
		if coyote_frame > 0:
			coyote_frame -= 1
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_frame > 0:
			jump_procedure()
		elif not is_on_floor():
			jump_buffer_frame = max_jump_buffer_frame
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= jump_lost_multiplier

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
				launch_h_direction = -direction.x
				launch_h = max_launch_h
			# 	if direction.y == 0:
			# 		velocity.x = -direction.x * max_launch_h * 1.2
			# 	else:
			# 		velocity.x = -direction.x * max_launch_h
			if direction.y != 0:
				velocity.y = jump_velocity * direction.y

func strike_hold_input():
	if not can_strike:
		if not Input.is_action_pressed("strike_left") and \
			not Input.is_action_pressed("strike_right") and \
			not Input.is_action_pressed("strike_up") and \
			not Input.is_action_pressed("strike_down"):
			can_strike = true

func launch_h_lost():
	if launch_h > 0.0:
		if not is_on_floor():
			launch_h = move_toward(launch_h, 0, air_friction)
		else:
			launch_h = move_toward(launch_h, 0, friction)

func jump_buffer_frame_countdown():
	if jump_buffer_frame > 0:
		jump_buffer_frame -= 1
		if is_on_floor() and jump_buffer_frame > 0:
			print("You jump before hitting the ground")
			jump_procedure()

func _ready():
	state.travel("idle")

func _physics_process(delta):
	jump_buffer_frame_countdown()
	jump(delta)
	move()
	strike()
	strike_hold_input()
	#launch_h_lost()
	move_and_slide()

func _on_strike_delay_timer_timeout():
	on_strike_delay = false
