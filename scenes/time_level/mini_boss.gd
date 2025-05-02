extends CharacterBody2D

@export var speed: float = 80.0
@export var move_distance: float = 130.0  # How far down it moves (roughly from -20 to 160)
@export var pause_time: float = 0.8  # Pause at the bottom/top before moving again
@export var side_x_positions: Array = [300.0, 10.0]  # Right side first, then left
@export var start_y: float = -30.
@export var coconut_scene: PackedScene
@export var poo_scene: PackedScene
@export var max_health: int = 3 # Max hearts
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

var health_bar: HBoxContainer
var current_health: int
var direction := Vector2.LEFT
var moving_down = true
var current_side = 0  # 0 = right, 1 = left
var paused = false
var is_offscreen = false
var shoot_cooldown = 0.0
var is_dead = false
var death_fall_speed = 100.0
var is_throwing = false

func _ready():
	$AnimatedSprite2D.play("fly")
	health_bar = get_parent().get_node("HealthBar")
	position = Vector2(side_x_positions[current_side], start_y)
	current_health = max_health

func _physics_process(delta):
	if paused or is_dead:
		return
	
	if is_throwing:
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
	
	if not paused and not is_offscreen:
		shoot_cooldown -= delta
		if shoot_cooldown <= 0.0:
			_shoot_coconut()
			shoot_cooldown = randf_range(1.5, 2)

func move_offscreen():
	is_offscreen = true
	paused = true
	moving_down = true
	
	# Phase 1: Warning phase (2 seconds)
	await get_tree().create_timer(1).timeout
	
	# Phase 2: Poo rain attack (4 seconds)
	var attack_timer = 4.0
	while attack_timer > 0.0:
		spawn_poo()
		var wait_time = randf_range(0.2, 0.5)  # Random small delay between poos
		await get_tree().create_timer(wait_time).timeout
		attack_timer -= wait_time
		
	# Phase 3: Cooldown phase (2 seconds)
	await get_tree().create_timer(1).timeout
	await move_to_offscreen()
	await move_to_other_side()
	paused = false

func move_to_offscreen():
	# Move up further to look like flying offscreen
	var target_y = -10.0
	while position.y > target_y:
		position.y -= speed * 0.5 * get_process_delta_time()
		await get_tree().process_frame
	is_offscreen = false
		
func move_to_other_side():
	# Teleport to the other side and reappear
	current_side = (current_side + 1) % 2
	position = Vector2(side_x_positions[current_side], -20.0)

	# Flip the sprite depending on which side
	$AnimatedSprite2D.flip_h = current_side == 1

func _shoot_coconut():
	if is_offscreen:
		return  # Don't shoot if boss is offscreen
	if global_position.y <= 20:
		return  # Don't shoot if boss is too high
	if is_dead == true:
		die()
	if coconut_scene and $AnimatedSprite2D:
		is_throwing = true
		$AnimatedSprite2D.play("throw")  # Play throw animation
		if is_dead == true:
			die()
		spawn_coconut_delayed()

func spawn_coconut_delayed() -> void:
	if is_dead == false:
		await get_tree().create_timer(1).timeout  # Adjust timing to match throw animation
		spawn_coconut()
		$AnimatedSprite2D.play("fly")
		if is_dead == true:
			die()
		is_throwing = false  # Return to flying animation

func spawn_coconut():
	var proj = coconut_scene.instantiate()
	get_parent().add_child(proj)
	# Shoot coconuts in front of the boss
	var shoot_offset = Vector2(-30, 20)
	if current_side == 1:
		shoot_offset = Vector2(30, 20)
	proj.global_position = global_position + shoot_offset
	proj.direction = Vector2.LEFT if current_side == 0 else Vector2.RIGHT

func spawn_poo():
	if poo_scene:
		var poo = poo_scene.instantiate()
		get_parent().add_child(poo)
		# Spawn above the screen at random x positions
		var random_x = randf_range(0, 320)  # Assuming your scene is 320 wide
		poo.global_position = Vector2(random_x, -10)

func take_damage():
	current_health -= 1
	update_health_bar()
	print("Boss took damage! Current Health:", current_health)
	if current_health <= 0:
		die()

func update_health_bar():
	if health_bar == null:
		return
	for i in range(health_bar.get_child_count()):
		var heart = health_bar.get_child(i)
		if i < current_health:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture

func pause():
	paused = true
	await get_tree().create_timer(pause_time).timeout
	paused = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
		
	elif body.is_in_group("Coconuts"):
		if body.has_method("is_frozen") and body.is_frozen():
			body.break_apart()
		else:
			print("coconut")
			flash_red()
			take_damage()
			body.break_apart()

func flash_red() -> void:
	var sprite = $AnimatedSprite2D
	var original_modulate = sprite.modulate
	sprite.modulate = Color(1, 0, 0)  # Full red
	await get_tree().create_timer(0.3).timeout  # Wait 0.1 seconds
	sprite.modulate = original_modulate  # Go back to normal

func die():
	print("Boss defeated!")
	is_dead = true  
	paused = true
	is_offscreen = true
	PlayerState.slow_unlocked = false

	# Clear coconuts
	for coconut in get_tree().get_nodes_in_group("Coconuts"):
		coconut.queue_free()

	# Reset player time slow
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.is_time_slowed:
		player.reset_time_slow()

	# Play death animation
	if is_dead:
		var sprite = $AnimatedSprite2D
		sprite.play("death")

		# Tween fall to y = 148 (keep same x)
		var target_y := 148.0
		var tween := create_tween()
		tween.tween_property(self, "global_position:y", target_y, 2.0)  # Adjust time to match animation

		await tween.finished  # Wait for fall to finish

		# Fade out after fall
		var fade_tween := create_tween()
		fade_tween.tween_property(self, "modulate:a", 0.0, 1.5)  # 1.5 seconds to fade out

		await fade_tween.finished
		queue_free()
