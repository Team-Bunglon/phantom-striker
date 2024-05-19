extends CharacterBody2D
class_name Player

@export var strike_particle_length: float = 48	## The length of the strike particle emission spawner. Does NOT affect the target position of any directional RayCast2D.
@export var looking_left: bool = false			## The character will look left at the start of the level.
@export var camera_shake: bool = true			## Allow camera shaking upon striking impact or death. 
@export var strikable_tiles: Array[String] = ["TileMap", "SpikeMap", "BlackDiamond", "MovingPlatform", "MovingPlatformPoint", "GateMap"]  ## The tilemap/object that the strike raycast will detect upon and the character will bounce. The string will be checked using "begins_with()" method.
@export var unstrikable_tiles: Array[String] = ["RedTileMap", "RedSpikeMap"]
@export var reacting_tiles: Array[String]  = ["DisintegratingPlatform", "DisintegratablePlatform", "DestroyablePlatform"]  ## The tilemap/object that will react when being struck upon. The character will still bounce.
@export var kill_tiles: Array[String]	   = ["SpikeMap", "RedSpikeMap", "MovingHazard"] ## The tilemap/object that will kill the character upon contact. The string will be checked using "begins_with()" method.

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

@export_category("Falling")
@export var fall_time_to_terminal: float = 0.6 ## The time to reach terminal velocity during a fall, that is the state that the player can't gain anymore fall speed. Any action using 
@export var fall_stretch_multiplier: float = 0.4 ## The 
@onready var max_fall_speed: float = fall_gravity * fall_time_to_terminal

@export_category("Launching")
@export var reduced_height_multiplier: float = 0.666 ## The multiplier that reduces the height when striking the floor while crouching 
@export var white_diamond_x_multiplier: float = 1.333 ## The multiplier that increase the horizontal distance when striking the white diamond horizontally.
@export var white_diamond_y_multiplier: float = 1.333 ## The multiplier that increase the jump height when striking the white diamond upward (from below)
@export var white_diamond_dia_multiplier: Vector2 = Vector2(0.7, 1.0) ## The multiplier that applies to any diagonal launches

@export_category("Frames Timers")		 ## The timers in frame count (in 60FPS). Please use (and create if needed) a timer node for timer in seconds.
@export var jump_buffer_frame:	int = 8	 ## Let the character perform a jump as soon as he touches the floor if the jump button is pressed before reaching it while within the frame duration.
@export var coyote_frame:		int = 5  ## Let the character jump after walking off the platform's edge within the frame duration.
@export var wall_buffer_frame:	int = 4  ## Let the character to maintain his horizontal launch momentum when he hits a wall within the frame duration.
@export var strike_delay_frame:	int = 1	 ## Input delay for launch action. This is done to correctly register diagonal launch action. 
@export var move_delay_frame:	int = 10 ## Prevent the character from manually moving though the X axis after gaining horizontal launch within the frame duration.

@export_category("Sprite Stretch")
@export var stretch_vector:	Vector2 = Vector2(0.7, 1.3)	## The vector the sprite scale would change when being stretched or squashed.
@export var stretch_multiplier: float = 1.0				## The multiplier of how fast the gradual scalling would take

# Variables that will change
var velocity_prev:		Vector2 = Vector2.ZERO
var is_airborne:		bool = false
var is_falling_stretch: bool = false
var launch_x:			float = 0.0	 # The current launch speed on either X axis.
var launch_x_direction: float = 1.0  # The direction of the launch.
var jump_buffer_count:	int = 0
var coyote_count:		int = coyote_frame
var wall_buffer_count:	int = wall_buffer_frame
var strike_delay_count: int = strike_delay_frame
var move_delay_count:	int = 0
var on_strike_delay:	bool = false	# Boolean for $StrikeDelayTimer, or when the character can perform the next strike.
var can_move:			bool = false	# Boolean at the start of the level after the character spawns.
var can_strike:			bool = false	# Boolean to prevent the character from doing a continous striking when the strike input is being held.
var is_dying:			bool = false	# The character is in dying state (animation).
var on_moving_platform:	bool = false
var on_vertical_launch: bool = false
var face: Dictionary = {
	-1: "_left",
	0: "_right",
	1: "_right",
}

# Variables that shouldn't be changed
@onready var all_strikeable_tiles: Array[String] = strikable_tiles + reacting_tiles
@onready var strike_particle_preload: Resource = preload("res://objects/strike.tscn")
@onready var jump_particle_preload: Resource = preload("res://objects/jump.tscn")
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
	face[0] = face[-1] if looking_left else face[1]
	$AnimationPlayer.play("idle" + face[0])

func _input(event):
	if event.is_action_pressed("restart") and not is_dying:
		die(true)

func _physics_process(delta):
	if global_position.y >= 640 and not is_dying:
		die(true)
	if is_dying:
		velocity = Vector2.ZERO
		return
	_jump(delta)
	_jump_push()
	_strike()
	_strike_hold_input()
	_move()
	_move_delay_countdown()
	_move_procedure()
	_squash_sprite()
	_unstretch_sprite_delta(delta)

## Horizontal movement.
## This part is already so smooth I'm scared of changing anything.
func _move():
	var acceleration_current: float = acceleration * (Global.gamespeed / 100.0)
	var air_friction_current: float = air_friction * (Global.gamespeed / 100.0)
	var floor_friction_current: float = floor_friction * (Global.gamespeed / 100.0)

	var direction = Input.get_axis("move_left", "move_right") if can_move else 0.0

	if not is_on_floor() and direction != launch_x_direction:
		launch_x = move_toward(launch_x, 0, air_friction_current)
	elif is_on_floor():
		launch_x = move_toward(launch_x, 0, air_friction_current*4)

	var max_speed_current = max_speed
	if Input.is_action_pressed("slow"):
		max_speed_current /= 3
	var direction_move = direction * max_speed_current
	var launch_x_move = launch_x_direction * launch_x
	velocity_prev.x = velocity.x

	if direction and move_delay_count == 0: # When the input is pressed.
		if launch_x > 0.0: # Launch speed logic
			if direction == launch_x_direction: # Towards the launch direction. They should maintain its speed
				velocity.x = max(launch_x_move, direction_move) if direction > 0 else min(launch_x_move, direction_move)
				_wall_buffer_countdown()
				if velocity.x == direction_move: # If launch speed < movement speed, set it to 0.
					launch_x = 0.0
			else: # Against the launch direction.
				launch_x = move_toward(launch_x, 0, air_friction_current * 4)
				if launch_x < 0.0 or is_on_wall_only(): # Stop when launch speed is 0 or on the wall.
					launch_x = 0.0
				velocity.x = launch_x * launch_x_direction
		else: # Normal walking logic
			velocity.x = move_toward(velocity.x, direction_move, acceleration_current)
	else: # When the input is not pressed.
		if launch_x > 0.0:
			velocity.x = launch_x_move
			_wall_buffer_countdown()
		else:
			velocity.x = move_toward(velocity.x, 0, floor_friction_current)
	_player_state(int(direction))

## Performing said horizonal movement
func _move_procedure():
	var collision = move_and_slide()
	if collision:
		var collision_info = get_last_slide_collision() # Access collision information
		if collision_info: # Check if the collider is a SpikeMap or MovingHazard
			var collider = collision_info.get_collider()
			var collider_name: String
			if collider.name.begins_with("@AnimatableBody2D") and collider.has_method("get_strike_name"):
				collider_name = collider.get_strike_name()
			else:
				collider_name = collider.name.trim_suffix(str(collider.name.to_int()))
			if collider_name in kill_tiles:
				die()
			if collider_name.begins_with("MovingPlatform") and Input.is_action_pressed("crouch"):
				on_moving_platform = true
			else:
				on_moving_platform = false

## Get gravity depending if the character is jumping or falling.
func _get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

## Vertical Movement
func _jump(delta):
	velocity_prev.y = velocity.y
	velocity.y += _get_gravity() * delta
	if velocity.y >= max_fall_speed:
		velocity.y = max_fall_speed
	if velocity.y >= 0 and not is_on_floor() and can_move:
		on_vertical_launch = false
		is_airborne = true
		if velocity.y >= fall_gravity * jump_time_to_descend * 0.4:
			_stretch_sprite_delta(delta)
	_coyote_countdown()
	_jump_buffer_countdown()
	if Input.is_action_just_pressed("jump"):
		if on_moving_platform:
			global_position.y += 4
		elif (is_on_floor() or coyote_count > 0) and can_move:
			_jump_procedure()
		elif not is_on_floor() or not can_move:
			jump_buffer_count = jump_buffer_frame
	if Input.is_action_just_released("jump") and velocity.y < 0.0 and not on_vertical_launch:
		velocity.y /= jump_lost_multiplier

## Performing said vertical movement
func _jump_procedure():
	_stretch_sprite()
	Audio.play("Jump")
	_jump_particle_create()
	velocity.y = -jump_velocity
	coyote_count = 0
	jump_buffer_count = 0

func _jump_particle_create():
	var jump_particle: Jump = jump_particle_preload.instantiate()
	jump_particle.emitting($Center.global_position, velocity.x)
	get_parent().add_child(jump_particle)

## Pushing the player when the portion of his head hits the celling instead of stopping him.
func _jump_push():
	if velocity.y >= 0.0:
		return
	if $RayPushL.is_colliding() and \
		not $RayPushM.is_colliding() and \
		not $RayPushR.is_colliding():
			var collider_name: String = $RayPushL.get_collider().name
			if not collider_name in kill_tiles:
				global_position.x += 6
	elif $RayPushR.is_colliding() and \
		not $RayPushM.is_colliding() and \
		not $RayPushL.is_colliding():
			var collider_name: String = $RayPushR.get_collider().name
			if not collider_name in kill_tiles:
				global_position.x -= 6

## The strike function
func _strike():
	var direction_x = Input.get_axis("strike_left", "strike_right")	  # Left is -1, right is +1
	var direction_y = Input.get_axis("strike_up", "strike_down") * -1 # Down is -1, up is +1
	var direction_xy = Vector2(direction_x, direction_y) if can_move else Vector2.ZERO
	if not on_strike_delay and can_strike and direction_xy != Vector2.ZERO:
		if strike_delay_count > 0:
			strike_delay_count -= 1
		else:
			var strike_raycast: RayCast2D = get_node(strike_dir[direction_xy][1])
			_strike_response(direction_xy, strike_raycast)
			_strike_particle_create(strike_raycast)
			strike_delay_count = strike_delay_frame
			on_strike_delay = true
			can_strike = false
			direction_xy = Vector2.ZERO
			Audio.play("Strike")
			$StrikeDelayTimer.start()

## Create particle for strike
func _strike_particle_create(raycast: RayCast2D):
	var strike_particle: Strike = strike_particle_preload.instantiate()

	var strike_length: float = strike_particle_length
	var strike_position: Vector2 = $Center.global_position
	if raycast.is_colliding():
		var collide_length = strike_position.distance_to(raycast.get_collision_point())
		strike_length = collide_length * strike_particle_length / raycast.target_position.y

	strike_particle.emitting(strike_position, raycast.rotation, strike_length)
	get_parent().add_child(strike_particle)

## Getting reaction from said strike
func _strike_response(direction: Vector2, raycast: RayCast2D):
	var temp_mult := 1.0
	if Input.is_action_pressed("crouch"):
		temp_mult = reduced_height_multiplier
	if raycast.is_colliding():
		var collider := raycast.get_collider()
		var collider_name: String
		if collider.name.begins_with("@AnimatableBody2D") and collider.has_method("get_strike_name"):
			collider_name = collider.get_strike_name()
		else:
			collider_name = collider.name.trim_suffix(str(collider.name.to_int()))
		if collider.has_method("struck"):
			collider.struck()
		if collider_name in all_strikeable_tiles:
			if camera_shake:
				$Camera2D.shake(4,12)
			if collider_name in reacting_tiles: 
				var coords = raycast.get_collision_point() - raycast.get_collision_normal()
				if collider.has_method("break_platform"):
					collider.break_platform(collider.local_to_map(coords))
			if direction.x != 0.0:
				move_delay_count = move_delay_frame
				launch_x_direction = -direction.x
				launch_x = max_launch_x
				if velocity.y > 0.0:
					velocity.y = 0.0
				_player_state(int(launch_x_direction))
			if direction.y < 0.0: # Going Up
				on_vertical_launch = true
				velocity.y = jump_velocity * direction.y * temp_mult		
			elif direction.y > 0.0: # Going Down
				velocity.y = max_fall_speed
			# Sprite Stretching Function
			if direction.x == 0.0 and direction.y != 0.0: _stretch_sprite()
			elif direction.x != 0.0: _unstretch_sprite()
		elif raycast.get_collider().name.begins_with("WhiteDiamond"):
			if direction.x != 0.0:
				move_delay_count = move_delay_frame
				launch_x_direction = direction.x
				launch_x = max_launch_x * white_diamond_x_multiplier
				if velocity.y > 0.0:
					velocity.y = 0.0
				_player_state(int(-launch_x_direction))
			if direction.y < 0.0: # Going Down
				velocity.y = max_fall_speed
			elif direction.y > 0.0: # Going Up
				on_vertical_launch = true
				velocity.y = -jump_velocity * direction.y * white_diamond_y_multiplier
			if direction.x != 0.0 and direction.y > 0.0: # Going diagonal. Fall speed won't be multiplied when going diagonal down.
				launch_x *= white_diamond_dia_multiplier.x
				velocity.y *= white_diamond_dia_multiplier.y
			# Sprite Stretching Function
			if direction.x == 0.0 and direction.y != 0.0: _stretch_sprite()
			elif direction.x != 0.0: _unstretch_sprite()
		elif collider_name in unstrikable_tiles:
			Audio.play("Red")
			if camera_shake:
				$Camera2D.shake(2,24)

## A wrapper to check if none of the strike button are pressed.
## I'm sure there's a better way than this.
func _check_strike_input():
	return not Input.is_action_pressed("strike_left") and not Input.is_action_pressed("strike_right") and not Input.is_action_pressed("strike_up") and not Input.is_action_pressed("strike_down")

## Prevent the character from holding down the strike button and continuously striking.
func _strike_hold_input():
	if not can_strike:
		if _check_strike_input():
			can_strike = true

## When the player presses the jump button just before landing on the ground or when can_move is false,
## jump_buffer_count will start counting down.
## The character will automatically jump as soon as he touches the ground or can_move is true
## as long as the count is above zero
func _jump_buffer_countdown():
	if jump_buffer_count > 0:
		jump_buffer_count -= 1
		if is_on_floor() and can_move and jump_buffer_count > 0:
			_jump_procedure()

## When a character is walking off the ledge, coyote_count will start counting down.
## As long as the count is above zero, the player can jump in midair.
func _coyote_countdown():
	if is_on_floor():
		coyote_count = coyote_frame
	else:
		if coyote_count > 0:
			coyote_count -= 1

## When the character is launched and touches a wall, 
## wall_buffer_count will start count down while still keeping his launch speed. 
## After wall_buffer_frame of frame has passed, he loses all launch speed.
func _wall_buffer_countdown():
	if is_on_wall():
		if wall_buffer_count > 0:
			wall_buffer_count -= 1
		elif wall_buffer_count <= 0:
			launch_x = 0
			wall_buffer_count = wall_buffer_frame
	elif not is_on_wall():
		wall_buffer_count = wall_buffer_frame

## When the character gain horizontal launch speed through a strike, 
## move_delay_count will start counting down.
## The character cannot move as long as the count is above zero. 
func _move_delay_countdown():
	if move_delay_count > 0:
		move_delay_count -= 1

## Character animation. We don't need blend tree after all.
func _player_state(direction: int):	
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

## Stretch the sprite immediately when jumping or launching vertically (but not-diagonally).
func _stretch_sprite():
	is_airborne = true
	is_falling_stretch = false
	$Sprite.scale = stretch_vector

## Stretch the sprite gradually when falling.
func _stretch_sprite_delta(delta):
	is_airborne = true
	is_falling_stretch = true
	$Sprite.scale.x = move_toward($Sprite.scale.x, stretch_vector.x, stretch_multiplier * delta)
	$Sprite.scale.y = move_toward($Sprite.scale.y, stretch_vector.y, stretch_multiplier * delta)

## Squash the sprite immediately when landing.
func _squash_sprite():
	if is_on_floor() and is_airborne and not is_dying:
		is_airborne = false
		is_falling_stretch = false
		$Sprite.scale = Vector2(stretch_vector.y, stretch_vector.x)

## Unstretch the sprite immediately
func _unstretch_sprite():
	$Sprite.scale = Vector2.ONE

## Unstretch the sprite gradually
func _unstretch_sprite_delta(delta):
	if not is_falling_stretch:
		$Sprite.scale.x = move_toward($Sprite.scale.x, 1, stretch_multiplier * delta)
		$Sprite.scale.y = move_toward($Sprite.scale.y, 1, stretch_multiplier * delta)

## Kill the character and restart the level. Should be called when killing him on other script.
## quick_death skips the first animation before the character explodes.
func die(quick_death := false):
	Global.death_count += 1
	is_dying = true
	$Sprite.scale = Vector2.ONE
	if quick_death:
		_explode()
	else:
		Audio.play("Hit")
		$AnimationPlayer.play("die" + face[0])

## Explode animation for the character
func _explode():
	if camera_shake: $Camera2D.shake()
	Audio.play("Death")
	$Sprite.visible = false
	$DieParticle.emitting = true
	$ExplodeTimer.start()

# signal function stuff
func _on_strike_delay_timer_timeout():
	on_strike_delay = false

func _on_explode_timer_timeout():
	get_tree().reload_current_scene()

func _on_cooldown_timer_timeout():
	can_move = true
	if _check_strike_input(): can_strike = true

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name.begins_with("die"):
		_explode()
