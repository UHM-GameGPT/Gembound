extends CharacterBody2D

@export var fly_speed: float = 60.0
@export var left_limit: float = -180.0
@export var right_limit: float = 100.0

var direction: int = 1
var start_position: Vector2

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("flying")

func _physics_process(delta: float) -> void:
	if global_position.x > start_position.x + right_limit:
		direction = -1
	elif global_position.x < start_position.x + left_limit:
		direction = 1

	$AnimatedSprite2D.flip_h = direction > 0

	velocity = Vector2(fly_speed * direction, 0)
	move_and_slide()
