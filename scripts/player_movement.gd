extends CharacterBody2D

class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 400.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer = $Jump
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var run_dirt_sand: AudioStreamPlayer = $Run_Dirt_Sand
@onready var spawn_point = get_parent().get_node("PlayerSpawn")

var landing: bool = false
var is_dead: bool = false
var can_move: bool = true

# Dashing variables
var can_dash: bool = false
var is_dashing: bool = false
var dash_time: float = 0.0
var dash_cooldown: float = 0.0
var dash_direction: float = 0.0

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	can_dash = PlayerState.dash_unlocked
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	landing = false
	animated_sprite.stop()
	if (direction == "left"):
		animated_sprite.flip_h = true
	elif (direction == "right"):
		animated_sprite.flip_h = false

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	# Allows the player to dash
	if dash_cooldown > 0:
		dash_cooldown -= delta

	if is_dashing:
		dash_time -= delta
		if dash_time <= 0:
			is_dashing = false
		else:
			velocity.x = dash_direction * DASH_SPEED
			move_and_slide()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()
		landing = true;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# get the input direction -1, 0, 1
	var direction := Input.get_axis("left", "right")
	
	# flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true	
	
	# Let the player dash if they are allowed to + finish dashing
	if Input.is_action_just_pressed("dash") and can_dash and dash_cooldown <= 0:
		_start_dash(direction)

	# Play animations if player is not dashing
	if not is_dashing:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle_right")
				
				# Stop playing walking soundfx
				if run_dirt_sand.playing:
					run_dirt_sand.stop()
			else:
				animated_sprite.play("walk_right")
				
				# Play walking soundfx
				if not run_dirt_sand.playing:
					run_dirt_sand.play()
		else:
			animated_sprite.play("jumping")
			if run_dirt_sand.playing:
				run_dirt_sand.stop()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if is_on_floor() and landing:
		jump_land.play()
		landing = false
	elif not is_on_floor():
		landing = true

func die():
	if is_dead: return
	is_dead = true

	animated_sprite.play("death")
	set_physics_process(false)
	$CollisionShape2D.call_deferred("set_disabled", false)

	await get_tree().create_timer(1).timeout

	global_position = spawn_point.global_position
	animated_sprite.play("idle_right")

	is_dead = false
	set_physics_process(true)
	$CollisionShape2D.call_deferred("set_disabled", false)
	
func _input(event : InputEvent):
	if(event.is_action_pressed("down")):
		position.y += 1

# Dashing motion for player
func _start_dash(direction: float) -> void:
	if direction == 0:
		direction = 1 if not animated_sprite.flip_h else -1
	is_dashing = true
	dash_time = DASH_DURATION
	dash_cooldown = DASH_COOLDOWN
	dash_direction = direction
	animated_sprite.play("dash")
