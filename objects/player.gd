extends CharacterBody2D
class_name Player

@export var strike_particle_length: float = 48 ## The length of the strike particle emission spawner. Does NOT affect the target position of any directional RayCast2D.

@export_category("Max Statistic")			## The maximum state the player can reach
@export var max_speed:		 float = 300.0	## The maximum speed of the character when manually moving on either X axis.
@export var max_launch_x:	 float = 600.0	## The maximum horizontal launch speed. The direction will be calculated after a successful strike.
@export var max_jump_height: float = 400.0	## The maximum jump height the character can reach.

@export_category("Acceleration")			## Variable to change velocity per frame.
@export var acceleration:	float = 100.0	## The acceleration when the character starts moving from idle state to max_speed.
@export var floor_friction:	float = 120.0	## The deceleration when the character stops moving from current velocity.x to idle state while on the floor.
@export var air_friction:	float = 8.0		## The deceleration of which the player will lose their horizontal launch speed in the air.

@export_category("Jumping")					   ## Jumping timers in seconds
@export var jump_time_to_peak:	  float = 0.5  ## The time to reach max_jump_height as long as the player keeps holding the jump button.
@export var jump_time_to_descend: float = 0.4  ## The time to descend from max_jump_height towards the floor of which the character has previously jumped on.
@export var jump_lost_multiplier: float = 2.0  ## The mutiplier the jump velocity would lose when the plyer stops holding the jump button.
@onready var jump_velocity: float = ((2.0 * max_jump_height) / jump_time_to_peak)
@onready var jump_gravity:  float =	((2.0 * max_jump_height) / (jump_time_to_peak ** 2))
@onready var fall_gravity:  float =	((2.0 * max_jump_height) / (jump_time_to_descend ** 2))

@export_category("Launching")
@export var reduced_height_multiplier:	float = 1.5 ## The multiplier that reduces the height when striking the floor while crouching 

@export_category("Frames Timers")		 ## The timers in frame count (in 60FPS). Please use the timer node for timer in seconds.
@export var jump_buffer_frame:	int = 8	 ## Let the character perform a jump as soon as he touches the floor if the jump button is pressed before reaching it while within the frame duration.
@export var coyote_frame:		int = 5  ## Let the character jump after walking off the platform's edge within the frame duration.
@export var wall_frame:			int = 4  ## Let the character to maintain his horizontal launch momentum when he hits a wall within the frame duration.
@export var strike_delay_frame:	int = 1	 ## Input delay for launch action. This is done to correctly register diagonal launch action. 
@export var move_delay_frame: int = 10 ## Prevent the character from manually moving though the X axis after gaining horizontal launch within the frame duration.

# Variables that will change
var launch_x:			float = 0.0	 # The current launch speed on either X axis.
var launch_x_direction: float = 1.0  # The direction of the launch.
var jump_buffer_count:	int = 0
var coyote_count:		int = coyote_frame
var wall_count:			int = wall_frame
var strike_delay_count: int = strike_delay_frame
var move_delay_count:	int = 0
var on_strike_delay:	bool = false	# Boolean for $StrikeDelayTimer, or when the character can perform the next strike.
var can_strike:			bool = true		# Boolean to prevent the character from doing a continous striking when the strike input is being held.
var face: Dictionary = {
	-1: "_left",
	0: "_right",
	1: "_right",
}

# Variables that shouldn't be changed
@onready var state: Variant = $AnimationTree.get("parameters/playback")
@onready var strike_particle_preload: Resource = preload("res://objects/strike.tscn")
@onready var strike_dir: Dictionary = {
	#Vector2(x,y):	["animation_name", "RayCast2D_name"],
	Vector2(1,0):	["strike_right", "RayCastR"],
	Vector2(-1,0):	["strike_left", "RayCastL"],
	Vector2(0,1):	["strike_up", "RayCastU"],
	Vector2(0,-1):	["strike_down", "RayCastD"],
	Vector2(-1,1):	["strike_up_left", "RayCastUL"],
	Vector2(1,1):	["strike_up_right", "RayCastUR"],
	Vector2(1,-1):	["strike_down_right", "RayCastDR"],
	Vector2(-1,-1): ["strike_down_left", "RayCastDL"],
}

func _ready():
	state.travel("idle_right")

func _physics_process(delta):
	jump(delta)
	strike()
	strike_hold_input()
	move()
	move_delay_countdown()
	
	# TO IVAN: This is an interesting implementation
	# The way I would implemen it is to just create an area2D for the character as a hurtbox.
	# If the hurtbox detects the spike tile, the character will die.
	# Maybe this is a better implementation. I may encapsulate this in its own function.
	var collision = move_and_slide()
	if collision:
		# Access collision information
		var collision_info = get_last_slide_collision()
		# Check if the collider is a SpikeMap
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.name == "SpikeMap":
				# Moved to die() to handle death animation as well
				die(false)
				
	#move_and_slide()
	#var collision = move_and_collide(velocity * 1/3 * delta)
	#if collision:
		##print(collision.get_collider())
		#var collider = collision.get_collider()
		#if collider and collider.name == "SpikeMap":
			#get_tree().reload_current_scene()

## Horizontal Movement
func move():
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor() and direction != launch_x_direction:
		launch_x = move_toward(launch_x, 0, air_friction)
	elif is_on_floor():
		launch_x = move_toward(launch_x, 0, air_friction*4)
	var direction_move = direction * max_speed
	var launch_x_move = launch_x_direction * launch_x

	if direction and move_delay_count == 0:
		if launch_x > 0.0:
			# The character should maintain the launch speed when the player moves towards launch_x_direction
			if direction == launch_x_direction: 
				velocity.x = max(launch_x_move, direction_move) if direction > 0 else min(launch_x_move, direction_move)
				# If the launch speed is smaller thn the default movement speed, just set the launch speed to 0 altogether.
				# Hopefully, this fixes the occasional "sticky" movement issue
				if velocity.x == direction_move: 
					launch_x = 0.0
			# The character moves against the launch direction.
			else:	
				launch_x = move_toward(launch_x, 0, air_friction * 4)
				if launch_x < 0.0:
					launch_x = 0.0
				velocity.x = launch_x * launch_x_direction
		else:
			velocity.x = move_toward(velocity.x, direction_move, acceleration)
	else:
		if launch_x > 0.0:
			velocity.x = launch_x_move
			wall_countdown()
		else:
			velocity.x = move_toward(velocity.x, 0, floor_friction)
	player_state(int(direction))

## Vertical Movement
func jump(delta):
	velocity.y += get_gravity() * delta
	coyote_countdown()
	jump_buffer_countdown()
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_count > 0:
			jump_procedure()
		elif not is_on_floor():
			jump_buffer_count = jump_buffer_frame
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y /= jump_lost_multiplier

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity 

func jump_procedure():
	velocity.y = -jump_velocity
	coyote_count = 0
	jump_buffer_count = 0

func strike():
	var direction_x = Input.get_axis("strike_left", "strike_right")	  # Left is -1, right is +1
	var direction_y = Input.get_axis("strike_up", "strike_down") * -1 # Down is -1, up is +1
	var direction_xy = Vector2(direction_x, direction_y)
	if not on_strike_delay and can_strike and direction_xy != Vector2.ZERO:
		if strike_delay_count > 0:
			strike_delay_count -= 1
		else:
			var strike_raycast: RayCast2D = get_node(strike_dir[direction_xy][1])
			strike_response(direction_xy, strike_raycast)
			strike_particle_create(strike_raycast)
			strike_delay_count = strike_delay_frame
			on_strike_delay = true
			can_strike = false
			direction_xy = Vector2.ZERO
			$StrikeDelayTimer.start()

func strike_particle_create(raycast: RayCast2D):
	var strike_particle: Strike = strike_particle_preload.instantiate()
	strike_particle.set_default_length(strike_particle_length)

	var strike_length: float = strike_particle_length
	if raycast.is_colliding():
		var collide_length = global_position.distance_to(raycast.get_collision_point())
		strike_length = collide_length * strike_particle_length / raycast.target_position.y

	strike_particle.emitting(global_position, raycast.rotation, strike_length)
	get_parent().add_child(strike_particle)

func strike_response(direction: Vector2, raycast: RayCast2D):
	var temp_mult = 1
	if Input.is_action_pressed("crouch"):
		temp_mult = reduced_height_multiplier
	if raycast.is_colliding():
		print(raycast.get_collider().name)
		if raycast.get_collider().name == "TileMap" || raycast.get_collider().name == "BlackDiamond":
			if direction.x != 0:
				move_delay_count = move_delay_frame
				launch_x_direction = -direction.x
				launch_x = max_launch_x
				player_state(int(launch_x_direction))
			if direction.y < 0: # Going Up
				velocity.y = jump_velocity * direction.y / temp_mult
			elif direction.y > 0: # Going Down
				velocity.y = jump_velocity * direction.y * 2
		elif raycast.get_collider().name == "WhiteDiamond":
			if direction.x != 0:
				move_delay_count = move_delay_frame
				launch_x_direction = direction.x
				launch_x = -max_launch_x
				player_state(int(launch_x_direction))
			if direction.y < 0: # Going Up
				velocity.y = jump_velocity * direction.y / temp_mult
			elif direction.y > 0: # Going Down
				velocity.y = jump_velocity * direction.y * 2

func strike_hold_input():
	if not can_strike:
		if not Input.is_action_pressed("strike_left") and \
			not Input.is_action_pressed("strike_right") and \
			not Input.is_action_pressed("strike_up") and \
			not Input.is_action_pressed("strike_down"):
			can_strike = true

func jump_buffer_countdown():
	if jump_buffer_count > 0:
		jump_buffer_count -= 1
		if is_on_floor() and jump_buffer_count > 0:
			print("You jump before hitting the ground")
			jump_procedure()

func coyote_countdown():
	if is_on_floor():
		coyote_count = coyote_frame
	else:
		if coyote_count > 0:
			coyote_count -= 1

func wall_countdown():
	if is_on_wall():
		if wall_count > 0:
			wall_count -= 1
		elif wall_count <= 0:
			launch_x = 0
			wall_count = wall_frame
	elif not is_on_wall():
		wall_count = wall_frame

func move_delay_countdown():
	if move_delay_count > 0:
		move_delay_count -= 1

## Character animation. We don't need blend tree after all.
func player_state(direction: int):	
	face[0] = face[direction]
	if is_on_floor() and velocity.x == 0:
		if Input.is_action_pressed("crouch"):
			$AnimationPlayer.play("crouch" + face[direction])
		else:
			$AnimationPlayer.play("idle" + face[direction])
	elif is_on_floor() and velocity.x != 0:
		$AnimationPlayer.play("walk" + face[direction])
	elif not is_on_floor():
		$AnimationPlayer.play("jump" + face[direction])

## Kill the character and restart the level. Can be used when the player object is referenced in other script too!
## quick_death skips the first animation before the character explodes to pieces
func die(quick_death: bool):
	get_tree().reload_current_scene()

func _on_strike_delay_timer_timeout():
	on_strike_delay = false
