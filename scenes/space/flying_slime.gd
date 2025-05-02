extends Area2D
# How far to move left and right
@export var move_distance := 13.0
# How long it takes to move one direction
@export var move_duration := 1

# Track direction (1 = right, -1 = left)
var direction := 13
# Where the enemy started
var start_position := Vector2.ZERO
var is_dying = false
var active_tween: Tween = null


func _ready():
	# Save where the enemy begins
	start_position = global_position
	
	# Play idle animation
	$AnimatedSprite2D.play("idle")
	
	# Start the patrol loop
	var current_scene = get_tree().current_scene.name
	if current_scene == "SpaceCollect":
		start_patrol()

func start_patrol():
	while true:
		# Go left or right from the current position, not the start
		var target_position = global_position + Vector2(move_distance * direction, 0)

		active_tween = create_tween()
		active_tween.tween_property(self, "global_position", target_position, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		# Flip the sprite to face the direction
		$AnimatedSprite2D.flip_h = direction < 0

		# Wait for the tween to finish, then switch direction
		await active_tween.finished
		direction *= -1

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
	elif body.is_in_group("weights"):
		die()
	elif body is RigidBody2D:
		body.linear_velocity = Vector2.ZERO
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.play("death")
		body.queue_free()
		queue_free()

func die():
	if is_dying:
		return
	is_dying = true

	set_process(false)
	set_physics_process(false)

	if active_tween:
		active_tween.kill()

	$AnimatedSprite2D.play("death")

	await $AnimatedSprite2D.animation_finished

	queue_free()
