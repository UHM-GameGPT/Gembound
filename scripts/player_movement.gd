extends CharacterBody2D

class_name Player

var SPEED = 130.0
var JUMP_VELOCITY = -300.0
var DASH_SPEED = 350.0
const DASH_DURATION = 0.05
const DASH_COOLDOWN = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer = $Jump
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var run_dirt_sand: AudioStreamPlayer = $Run_Dirt_Sand
@onready var spawn_point = get_parent().get_node("PlayerSpawn")
@onready var time_slow_overlay := get_parent().get_node("TimeSlowOverlay")
@export var clone_scene: PackedScene = preload("res://scenes/space/clone.tscn")

var landing: bool = false
var is_dead: bool = false
var can_move: bool = true

var current_ability: Ability = null

# Dashing variables
var can_dash: bool = false
var is_dashing: bool = false
var dash_time: float = 0.0
var dash_cooldown: float = 0.0
var dash_direction: float = 0.0

# Time ability 1 (Stopping objects)
var can_stop: bool = false;

# Time ability 2 (Slowing down time)
var is_time_slowed = false  
var time_slow_cooldown := 0.0

var current_clone: Node = null

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	add_to_group("Player")
	can_dash = PlayerState.dash_unlocked
	can_stop = PlayerState.stop_unlocked
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	landing = false
	animated_sprite.stop()
	if (direction == "left"):
		animated_sprite.flip_h = true
	elif (direction == "right"):
		animated_sprite.flip_h = false

func _physics_process(delta: float) -> void:
	if is_time_slowed:
		delta /= Engine.time_scale
	
	if time_slow_cooldown > 0:
		time_slow_cooldown -= delta
		
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
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * 10)
			
func die():
	if not is_inside_tree():
		return
	time_slow_cooldown = 1.0
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("death")
	set_physics_process(false)
	if has_method("reset_time_slow"):
		reset_time_slow()
	SceneManager.reload_scene_after_delay(1.0)  # Tell the scene manager to reload after 1 second
	
func _input(event : InputEvent):
	if(event.is_action_pressed("down")):
		position.y += 1
	if event.is_action_pressed("use_ability"):
		use_ability()

# Dashing motion for player
func _start_dash(direction: float) -> void:
	if direction == 0:
		direction = 1 if not animated_sprite.flip_h else -1
	is_dashing = true
	dash_time = DASH_DURATION
	dash_cooldown = DASH_COOLDOWN
	dash_direction = direction
	animated_sprite.play("dash")

func use_ability():
	if PlayerState.clone_unlocked:
		spawn_clone()
	elif PlayerState.slow_unlocked and time_slow_cooldown <= 0:
		toggle_time_slow()

func toggle_time_slow():
	is_time_slowed = !is_time_slowed
	if is_time_slowed:
		Engine.time_scale = 0.4
		self.SPEED *= 2.2
		self.JUMP_VELOCITY *= 1.6
		self.DASH_SPEED *= 1.8
		time_slow_overlay.visible = true
	else:
		Engine.time_scale = 1.0
		self.SPEED = 130.0
		self.JUMP_VELOCITY = -300.0
		self.DASH_SPEED = 350.0
		time_slow_overlay.visible = false

func reset_time_slow():
	if is_time_slowed:
		Engine.time_scale = 1.0
		is_time_slowed = false
		SPEED = 130.0
		JUMP_VELOCITY = -300.0
		DASH_SPEED = 350.0
		time_slow_overlay.visible = false
		
func spawn_clone():
	if current_clone and is_instance_valid(current_clone):
		current_clone.queue_free()
	var clone_scene = preload("res://scenes/space/clone.tscn")
	var new_clone = clone_scene.instantiate()
	new_clone.global_position = global_position
	get_tree().current_scene.add_child(new_clone)
	current_clone = new_clone

func set_can_move(value: bool):
	can_move = value
