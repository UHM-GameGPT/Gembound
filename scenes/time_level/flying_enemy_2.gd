extends CharacterBody2D

@export var speed: float = 250.0
@export var left_limit: float = -185.0
@export var right_limit: float = 0.0

var direction: int = 1
var start_position: Vector2

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("flying")

func _physics_process(delta: float) -> void:
	# Move back and forth
	if global_position.x > start_position.x + right_limit:
		direction = -1
	elif global_position.x < start_position.x + left_limit:
		direction = 1

	velocity = Vector2(speed * direction, 0)
	$AnimatedSprite2D.flip_h = direction < 0
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
