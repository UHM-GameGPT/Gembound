extends Area2D
# How far to move left and right
@export var move_distance := 10.0
# How long it takes to move one direction
@export var move_duration := 1

# Track direction (1 = right, -1 = left)
var direction := 10
# Where the enemy started
var start_position := Vector2.ZERO

func _ready():
	# Save where the enemy begins
	start_position = global_position
	
	# Play idle animation
	$AnimatedSprite2D.play("idle")
	
	# Start the patrol loop
	var current_scene = get_tree().current_scene.name
	if current_scene == "time_level_2":
		start_patrol()
	if current_scene == "SpaceCloneEnemy":
		start_patrol()

func start_patrol():
	while true:
		# Go left or right from the current position, not the start
		var target_position = global_position + Vector2(move_distance * direction, 0)

		var tween = create_tween()
		tween.tween_property(self, "global_position", target_position, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		# Flip the sprite to face the direction
		$AnimatedSprite2D.flip_h = direction < 0

		# Wait for the tween to finish, then switch direction
		await tween.finished
		direction *= -1

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
		
	if body is RigidBody2D:
		print("Something hit the slime!")
		
		# Play hit sound effect
		# $HitSound.play()
		
		# Optional: stop log from moving
		body.linear_velocity = Vector2.ZERO

		# Wait before deleting (0.3 seconds)
		if body.has_method("set_should_respawn"):
			body.set_should_respawn(false)
		
		await get_tree().create_timer(0.1).timeout

		# Play death animation
		$AnimatedSprite2D.play("death")

		# Wait for animation to finish
		await $AnimatedSprite2D.animation_finished
		
		# THEN hide and remove both
		if is_instance_valid(body):
			body.queue_free()

		queue_free()
