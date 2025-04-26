extends CharacterBody2D

@export var speed: float = 40.0
@export var move_distance: float = 150.0  # How far down it moves (roughly from -20 to 160)
@export var pause_time: float = 0.5  # Pause at the bottom/top before moving again
@export var side_x_positions: Array = [300.0, 20.0]  # Right side first, then left
@export var start_y: float = -20.
@export var coconut_scene: PackedScene

var moving_down = true
var current_side = 0  # 0 = right, 1 = left
var paused = false

func _ready():
	$AnimatedSprite2D.play("fly")
	position = Vector2(side_x_positions[current_side], start_y)
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	if paused:
		return
	
	if moving_down:
		position.y += speed * delta
		if position.y >= start_y + move_distance:
			moving_down = false
			pause()
	else:
		position.y -= speed * delta
		if position.y <= start_y:
			move_offscreen()

func move_offscreen():
	# Start flying offscreen
	paused = true
	moving_down = true
	await get_tree().create_timer(0.5).timeout  # Small pause
	# Simulate flying offscreen then appearing on the other side
	await move_to_offscreen()
	await move_to_other_side()
	paused = false

func move_to_offscreen():
	# Move up further to look like flying offscreen
	var target_y = -100.0
	while position.y > target_y:
		position.y -= speed * 0.5 * get_process_delta_time()
		await get_tree().process_frame
		
func move_to_other_side():
	# Teleport to the other side and reappear
	current_side = (current_side + 1) % 2
	position = Vector2(side_x_positions[current_side], -20.0)

	# Flip the sprite depending on which side
	$AnimatedSprite2D.flip_h = current_side == 1

func _on_shoot_timer_timeout():
	if coconut_scene:
		var proj = coconut_scene.instantiate()
		get_parent().add_child(proj)
		
		# Set the position below the enemy
		proj.global_position = global_position + Vector2(0, 30)  # Adjust '16' to spawn just below

func pause():
	paused = true
	await get_tree().create_timer(pause_time).timeout
	paused = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.time_slow_cooldown = 1.0
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").play("death")
		
		body.set_physics_process(false)  # stop player movement if needed
		
		if body.has_method("reset_time_slow"):
			body.reset_time_slow()
		
		await get_tree().create_timer(1).timeout  # give the animation time
		get_tree().reload_current_scene()
	if body is CharacterBody2D and body.scene_file_path == preload("res://scenes/time_level/miniboss_coconuts.tscn").resource_path:
		print("Something hit the boss!")
		body.queue_free()
		queue_free()
