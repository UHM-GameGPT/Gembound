extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var speed: float = 50.0
@export var top_offset: float = -85.0
@export var bottom_offset: float = 50.0

var direction := 1
var start_y := 0.0

func _ready():
	start_y = position.y
	$AnimatedSprite2D.scale.x = -1 
	$AnimatedSprite2D.play("flying")
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	position.y += direction * speed * delta

	if position.y <= start_y + top_offset:
		direction = 1
	elif position.y >= start_y + bottom_offset:
		direction = -1

func _on_shoot_timer_timeout():
	if projectile_scene:
		var proj = projectile_scene.instantiate()
		get_parent().add_child(proj)
		
		# Set the position below the enemy
		proj.global_position = global_position + Vector2(0, 16)  # Adjust '16' to spawn just below

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
