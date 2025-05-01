extends CharacterBody2D

# === Exported Variables ===
@export var move_speed := 100.0
@export var dash_speed := 700.0
@export var tracking_max_speed := 5.0
@export var tracking_time_limit := 2.0  # Duration to track player
@export var max_health: int = 3
@export var asteroid_scene: PackedScene
@export var warning_scene: PackedScene
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

# === States ===
enum BossState { ENTERING, TRACKING, DROPPING, EXITING, STUNNED, DASHING, DEAD }
var current_state = BossState.ENTERING
var mini_attack_phase: int = 0  # Rotates from 0 → 1 → ...

# === Internal Variables ===
var player: Node2D = null
var target_position := Vector2(160, 30)
var is_tracking_player := false
var tracking_timer := 0.0
var carried_asteroid: Node = null
var health_bar: HBoxContainer
var current_health: int
var should_abort_dash := false
var is_moving_to_center := false
var is_pausing := false
var is_dashing_right := false
var is_dashing_left := false
var is_dashing_up := false
var is_recovering_from_stun := false
var dash_warning: Node = null
var has_started_shaking := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	PlayerState.clone_unlocked = true
	health_bar = get_parent().get_node("HealthBar")
	current_health = max_health
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("fly")
	$AttackTimer.start(2)  # Start the cycle after a short delay

func _physics_process(delta):
	if current_state == BossState.STUNNED and not is_recovering_from_stun:
		return

	if current_state == BossState.DEAD:
		return

	if is_moving_to_center:
		var step = move_speed * delta
		position.x = min(position.x + step, 160)
		if position.x >= 160:
			is_moving_to_center = false
			print("Reached center.")

	if is_tracking_player:
		tracking_timer += delta

		if player:
			position.x = lerp(position.x, player.global_position.x, tracking_max_speed * delta)

		if tracking_timer >= tracking_time_limit - 1.0 and not has_started_shaking and carried_asteroid:
			has_started_shaking = true
			if carried_asteroid.has_node("AnimatedSprite2D"):
				carried_asteroid.get_node("AnimatedSprite2D").play("shake")

		if tracking_timer >= tracking_time_limit:
			is_tracking_player = false
			is_pausing = true
			tracking_timer = 0.0
			has_started_shaking = false

			if carried_asteroid:
				carried_asteroid.reparent(get_parent())
				carried_asteroid.global_position = $AsteroidHolder.global_position
				carried_asteroid.can_float = true
				carried_asteroid.drop()
				carried_asteroid = null

			print("Finished tracking. Pausing.")
			$PauseTimer.start()


	if is_dashing_right:
		var step = dash_speed * delta
		position.x += step
		if position.x >= 400:
			is_dashing_right = false
			print("UFO dashed offscreen.")
	
	if is_dashing_left:
		var step = dash_speed * delta
		position.x -= step
		if position.x <= 312 and dash_warning:  # Once boss is onscreen
			dash_warning.queue_free()
			dash_warning = null
		if position.x <= -64:
			is_dashing_left = false
			print("UFO finished dash attack.")
			# Optionally trigger next state/reset

	if is_dashing_up:
		var step = move_speed * delta
		position.y -= step
		if position.y <= -40:
			is_dashing_up = false
			print("Finished dashing upward.")

	if is_recovering_from_stun:
		print("Mini Boss recovered")
		is_recovering_from_stun = false
		change_state(BossState.EXITING)
		mini_attack_phase = 2

	if is_pausing:
		pass

func change_state(new_state: int):
	current_state = new_state

func take_damage():
	current_health -= 1
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_bar():
	if health_bar == null:
		return
	for i in range(health_bar.get_child_count()):
		var heart = health_bar.get_child(i)
		heart.texture = full_heart_texture if i < current_health else empty_heart_texture

func die():
	if has_node("Hitbox"):
		$Hitbox.set_deferred("monitoring", false)

	# Disable the main collision body too
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	PlayerState.clone_unlocked = false
	change_state(BossState.DEAD)
	$AnimatedSprite2D.play("death")

	await get_tree().create_timer(7).timeout
	queue_free()
func stun():
	if current_state == BossState.STUNNED or current_state == BossState.DEAD:
		return

	print("Mini Boss is stunned!")
	change_state(BossState.STUNNED)
	is_dashing_left = false
	is_dashing_right = false

	await get_tree().create_timer(2.0).timeout  # Wait 3 seconds

	print("Mini Boss recovering from stun...")
	is_recovering_from_stun = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if current_state == BossState.DEAD:
		return  # Don't kill player if boss is dead
		
	if body.name == "Player":
		body.die()
	elif body.name == "clone" and body is CharacterBody2D:
		body.queue_free()
	elif body.is_in_group("Asteroid"):
		if current_state == BossState.STUNNED:
			take_damage()
		else:
			print("Boss destroys asteroid")
		body.queue_free()

func _on_pause_timer_timeout() -> void:
	is_pausing = false
	is_dashing_right = true
	change_state(BossState.EXITING)
	print("Pause complete. Dashing right.")

func _on_attack_timer_timeout() -> void:
	if current_state in [BossState.STUNNED, BossState.DEAD]:
		return  # Do not attack if stunned or dead
	match mini_attack_phase:
		0:
			print("Mini Boss Phase 0: Move to Center and Track")

			position = Vector2(-30, 30)
			change_state(BossState.ENTERING)

			# 🪨 Attach asteroid BEFORE UFO starts moving
			if carried_asteroid:
				carried_asteroid.queue_free()

			carried_asteroid = asteroid_scene.instantiate()
			carried_asteroid.can_float = false
			$AsteroidHolder.add_child(carried_asteroid)
			carried_asteroid.position = Vector2.ZERO

			is_moving_to_center = true
			await get_tree().create_timer(2.0).timeout  # Time for movement to center

			is_tracking_player = true
			tracking_timer = 0.0
			change_state(BossState.TRACKING)

			mini_attack_phase = 1
			$AttackTimer.start(4.0)

		1:
			print("Mini Boss Phase 1: Dash Attack")
			if warning_scene:
				dash_warning = warning_scene.instantiate()
				get_parent().add_child(dash_warning)
				dash_warning.global_position = Vector2(312, 128)  # Adjust Y to match UFO dash height
			await get_tree().create_timer(2.0).timeout
			position = Vector2(400, 128)  # Start offscreen right at correct height
			change_state(BossState.DASHING)
			is_dashing_left = true
			mini_attack_phase = 0
			$AttackTimer.start(3.0)
			
		2:
			print("Mini Boss Phase 2: Dashing upward after stun")
			change_state(BossState.DASHING)
			is_dashing_up = true
			mini_attack_phase = 0
			$AttackTimer.start(3.0)
