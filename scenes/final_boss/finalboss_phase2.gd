extends CharacterBody2D

@export var drop_target_y: float = 192.0
@export var drop_duration := 0.6
@export var delay_before_drop := 1.0
@export var follow_delay := 1.0  # seconds
@export var follow_speed := 200.0  # adjust as needed
@export var exclamation_scene: PackedScene
@export var asteroid_scene: PackedScene
@export var max_health: int = 5  # Max hearts
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D
@export var asteroid_drop_height := -20.0

var is_dead = false
var gravity := 100.0  # Tune this to match your game feel
var position_history: Array = []
var player: CharacterBody2D = null
var health_bar: HBoxContainer
var current_health: int
var can_follow := false
var is_dropping := true
var fall_velocity = Vector2.ZERO
var attack_phase: int = 0 
var is_paused_for_attack: bool = false
var is_invincible: bool = false
var is_flashing_red := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("set_can_move"):
		player.set_can_move(false)
	health_bar = get_parent().get_node("HealthBar")
	current_health = max_health
	position.y = 64  # Hold this position
	gravity = 0      # No gravity at start

	await get_tree().create_timer(delay_before_drop).timeout

	if player and player.has_method("set_can_move"):
		player.set_can_move(true)
	gravity = 1200.0
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("fly")
	is_dropping = true
	start_attack_cycle()

func _physics_process(delta):
	if is_dropping:
		fall_velocity.y += gravity * delta
		velocity = fall_velocity  # Set the built-in velocity
		move_and_slide()

		if is_on_floor():
			is_dropping = false
			fall_velocity = Vector2.ZERO
			velocity = Vector2.ZERO
			position_history.clear()
			can_follow = true  # ← FOLLOW BEHAVIOR STARTS HERE
			if has_node("AnimatedSprite2D"):
				$AnimatedSprite2D.play("fly")

	if can_follow and player and player.can_move:
		# Record player position history
		position_history.append({
			"position": player.global_position,
			"time": Time.get_ticks_msec() / 1000.0
		})

		# Keep only valid history
		while position_history.size() > 0 and (Time.get_ticks_msec() / 1000.0 - position_history[0]["time"]) > follow_delay:
			position_history.pop_front()

		# Move toward delayed position
		if position_history.size() > 0:
			var target_pos = position_history[0]["position"]
			var direction = (target_pos - global_position)

			# Only move if distance is significant (helps prevent shaking)
			if direction.length() > 10:
				direction = direction.normalized()
				global_position += direction * follow_speed * delta
			else:
				# Snap to position or do nothing
				pass

				# Flip sprite based on direction
				if direction.x < -0.1:
					$AnimatedSprite2D.flip_h = true
				elif direction.x > 0.1:
					$AnimatedSprite2D.flip_h = false

func start_attack_cycle():
	is_paused_for_attack = true
	$AttackTimer.start(0.1)  # Wait 1 second before shooting block

func take_damage():
	if is_invincible or is_dead:
		return  # Ignore damage during i-frames or if already dead

	is_invincible = true  # Enable i-frames
	current_health -= 1
	update_health_bar()
	print("Boss took damage! Current Health:", current_health)

	if current_health <= 0:
		is_dead = true
		PlayerState.slow_unlocked = false
		for coconut in get_tree().get_nodes_in_group("Asteroid"):
			coconut.queue_free()

	# Flash and start invincibility cooldown
	flash_red()
	await get_tree().create_timer(0.5).timeout  # I-frame duration
	is_invincible = false

func update_health_bar():
	if health_bar == null:
		return
	for i in range(health_bar.get_child_count()):
		var heart = health_bar.get_child(i)
		if i < current_health:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture

func flash_red() -> void:
	if is_flashing_red:
		return  # Already flashing

	is_flashing_red = true
	var sprite = $AnimatedSprite2D
	var original_modulate = sprite.modulate

	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout

	sprite.modulate = original_modulate
	is_flashing_red = false

func start_asteroid():
	var warning_positions: Array = []
	var used_x_positions: Array = []
	var num_to_spawn := 1
	var min_spacing := 50.0  # Minimum horizontal distance between asteroids

	while warning_positions.size() < num_to_spawn:
		var random_x = randf_range(20, 300)
		var too_close = false

		for x in used_x_positions:
			if abs(x - random_x) < min_spacing:
				too_close = true
				break

		if not too_close:
			var warning = exclamation_scene.instantiate()
			get_parent().add_child(warning)
			warning.global_position = Vector2(random_x, 10)
			warning_positions.append(warning)
			used_x_positions.append(random_x)

	await get_tree().create_timer(1.2).timeout  # Delay after warnings before asteroids drop

	for warning in warning_positions:
		var asteroid = asteroid_scene.instantiate()
		asteroid.global_position = warning.global_position + Vector2(0, asteroid_drop_height)
		get_parent().add_child(asteroid)
		warning.queue_free()

func _on_attack_timer_timeout() -> void:
	if attack_phase == 0:
		print("Phase 0 start: Throw Block")
		start_asteroid()
		is_paused_for_attack = false
		attack_phase = 0
		$AttackTimer.start(10.0)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroid") and "is_falling" in body and body.is_falling:
		print("Asteroid Hit!")
		flash_red()
		take_damage()
	if body.name == "Player":
		body.die()
