extends Area2D

@export var speed: float = 1800.0
var direction := Vector2.DOWN
var has_reflected := false
var rain_mode: bool = false
var already_killed_player = false

func _ready():
	add_to_group("Lasers")

func _physics_process(delta):
	position += direction * speed * delta

func set_direction(new_direction: Vector2):
	direction = new_direction

func _on_body_entered(body: Node2D) -> void:
	if already_killed_player:
		return
	if body.is_in_group("Player"):
		already_killed_player = true  # Mark player as dead
		if body.has_method("die"):
			body.die()
