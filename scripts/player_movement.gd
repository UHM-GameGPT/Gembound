extends CharacterBody2D

class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer = $Jump
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var spawn_point = get_parent().get_node("PlayerSpawn")

var landing: bool = false
var is_dead: bool = false

func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	landing = false
	animated_sprite.stop()
	if (direction == "left"):
		animated_sprite.flip_h = true
	elif (direction == "right"):
		animated_sprite.flip_h = false

func _physics_process(delta: float) -> void:
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
