extends CharacterBody2D

class_name Player

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
	
func _input(event : InputEvent):
	if(event.is_action_pressed("down")):
		position.y += 1
