extends CharacterBody2D

@export var follow_speed: float = 300.0  # Match player movement speed
@export var x_position: float = 300.0  # Fixed right side X position
@export var glass_block_scene: PackedScene
@export var laser_scene: PackedScene
@export var max_health: int = 3  # Max hearts
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D
@export var exclamation_scene: PackedScene
@export var rain_laser_scene: PackedScene

var is_dead = false
var health_bar: HBoxContainer
var current_health: int
var attack_phase: int = 0  # 0 = idle, 1 = throwing block, 2 = charging laser (later)
var is_paused_for_attack: bool = false
var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health_bar = get_parent().get_node("HealthBar")
	current_health = max_health
	position.x = x_position  # Lock boss to right side
	$AnimatedSprite2D.scale.x = -1 
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("fly")  # Start flying animation
	start_attack_cycle()

func _physics_process(delta):
	if player == null:
		return
		
	# Boss stands still if preparing attack
	if is_paused_for_attack or is_dead:
		return
	
	position.x = x_position
	
	var target_y = player.global_position.y
	global_position.y = lerp(global_position.y, target_y, 10 * delta)

func start_attack_cycle():
	is_paused_for_attack = true
	$AttackTimer.start(0.5)  # Wait 1 second before shooting block

func throw_glass_block():
	if glass_block_scene:
		var block = glass_block_scene.instantiate()
		get_parent().add_child(block)

		# Start block as invisible
		block.modulate.a = 0.0

		# Make block fade in over 1.4 seconds (same as wait time)
		var fade_tween = create_tween()
		fade_tween.tween_property(block, "modulate:a", 1.0, 1.4)

		block.attach_to_boss(self)  # Attach block to boss initially
		await get_tree().create_timer(1.4).timeout
		# Wait a little, then launch it
		launch_block_later(block)

func launch_block_later(block):
	$AnimatedSprite2D.play("punch")
	await get_tree().create_timer(1.1).timeout  # Wait 1 second while attached
	if block and block.is_inside_tree():
		block.launch()
		$AnimatedSprite2D.play("fly")

func fire_laser():
	if laser_scene:
		print("Laser Fired")
		var laser = laser_scene.instantiate()
		get_parent().add_child(laser)
		laser.global_position = global_position + Vector2(-20, 0)
	
	await get_tree().create_timer(1).timeout
	clear_glass_blocks()

func clear_glass_blocks():
	for block in get_tree().get_nodes_in_group("GlassBlocks"):
		if block.has_method("break_and_destroy"):
			block.break_and_destroy()
		else:
			block.queue_free()

func take_damage():
	current_health -= 1
	update_health_bar()
	print("Boss took damage! Current Health:", current_health)
	if current_health <= 0:
		is_dead = true
		PlayerState.slow_unlocked = false
		for coconut in get_tree().get_nodes_in_group("GlassBlocks"):
			coconut.queue_free()
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.is_time_slowed:
			player.reset_time_slow()
		start_phase_two_transition()

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
	var sprite = $AnimatedSprite2D
	var original_modulate = sprite.modulate
	sprite.modulate = Color(1, 0, 0)  # Full red
	await get_tree().create_timer(0.3).timeout  # Wait 0.1 seconds
	sprite.modulate = original_modulate  # Go back to normal

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()

func start_laser_rain():
	var warning_positions: Array = []

	# Spawn 3 warnings at random X positions
	for i in range(6):
		var random_x = randf_range(20, 200)  # Adjust based on your screen size
		var warning = exclamation_scene.instantiate()
		get_parent().add_child(warning)
		warning.global_position = Vector2(random_x, 10)
		warning_positions.append(warning)

	await get_tree().create_timer(1.5).timeout  # Wait for player to react

	# Spawn 3 rain lasers at warning positions
	for warning in warning_positions:
		if rain_laser_scene:
			var rain_laser = rain_laser_scene.instantiate()
			get_parent().add_child(rain_laser)
			rain_laser.global_position = Vector2(warning.global_position.x, warning.global_position.y + 100)

		warning.queue_free()

func _on_attack_timer_timeout() -> void:
	if attack_phase == 0:
		print("Phase 0 start: Throw Block")
		throw_glass_block()
		is_paused_for_attack = false
		attack_phase = 1
		$AttackTimer.start(5.0)
	elif attack_phase == 1:
		print("Phase 1 start: Fire Laser")
		$AnimatedSprite2D.play("charge")
		await get_tree().create_timer(2.0).timeout
		fire_laser()
		is_paused_for_attack = false
		attack_phase = 2
		$AnimatedSprite2D.play("fly")
		$AttackTimer.start(2.0)
	elif attack_phase == 2:
		print("Phase 2 start: Rain Laser")
		$AnimatedSprite2D.play("charge")
		await get_tree().create_timer(1.0).timeout
		start_laser_rain()
		is_paused_for_attack = false
		attack_phase = 0
		$AnimatedSprite2D.play("fly")
		$AttackTimer.start(4.0)

func start_phase_two_transition():
	is_paused_for_attack = true
	set_physics_process(false)

	# Stop player movement
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.set_physics_process(false)

	# Turn off boss hitbox
	if has_node("Hitbox"):
		$Hitbox.set_deferred("monitoring", false)

	# STOP the attack timer
	if has_node("AttackTimer"):
		$AttackTimer.stop()

	# Move boss to center
	var target_position = Vector2(160, 64)
	move_to_middle(target_position)

func move_to_middle(target_position: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 1.5)
	tween.finished.connect(_on_middle_reached)
	
func _on_middle_reached():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("attack")  # Play snap animation
	
	await get_tree().create_timer(2.0).timeout  # Adjust this to match snap animation length
	
	start_screen_fade()
	
func start_screen_fade():
	var fade = ColorRect.new()
	fade.modulate = Color(1, 1, 1, 0)  # White but fully transparent using modulate!
	fade.size = get_viewport().size
	get_tree().current_scene.add_child(fade)

	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 2.0)  # Fade to full white over 2 seconds
	tween.finished.connect(_on_fade_complete)

func _on_fade_complete():
	get_tree().change_scene_to_file("res://scenes/final_boss/final_boss_phase2.tscn")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lasers"):
		print("Laser Hit!")
		flash_red()
		take_damage()
