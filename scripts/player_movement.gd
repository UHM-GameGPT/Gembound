extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# get the input direction -1, 0, 1
	var direction := Input.get_axis("left", "right")
	
	# flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true	
	
	# play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle_right")
		else:
			animated_sprite.play("walk_right")
	else:
		animated_sprite.play("jumping")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

"""
extends CharacterBody2D

var max_speed = 100;
var last_direction = Vector2(1,0)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
	else:
		play_idle_animation(last_direction)

func play_walk_animation(direction):
	if direction.x > 0:
		animated_sprite.play("walk_right")
	elif direction.x < 0:
		animated_sprite.play("walk_left")

func play_idle_animation(direction):
	if direction.x > 0:
		animated_sprite.play("idle_right")
	elif direction.x < 0:
		animated_sprite.play("idle_left")
"""
