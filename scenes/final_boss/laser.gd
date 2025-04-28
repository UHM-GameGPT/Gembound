extends Area2D

@export var speed: float = 600.0
var direction := Vector2.LEFT
var has_reflected := false

func _ready():
	add_to_group("Lasers")
	$CollisionShape2D.disabled = true  
	start_enable_collision_timer()

func _physics_process(delta):
	position += direction * speed * delta

func start_enable_collision_timer():
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false  # Turn collision back on

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("GlassBlocks") and body.has_method("is_frozen") and body.is_frozen() and not has_reflected:
		direction = Vector2.RIGHT  # Reflect back toward boss
		body.queue_free()
		has_reflected = true
	elif body.is_in_group("Player"):
		# Hit player normally
		body.time_slow_cooldown = 1.0
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").play("death")
		body.set_physics_process(false)
		if body.has_method("reset_time_slow"):
			body.reset_time_slow()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
