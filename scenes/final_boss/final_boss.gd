extends CharacterBody2D

@export var follow_speed: float = 300.0  # Match player movement speed
@export var x_position: float = 300.0  # Fixed right side X position
@export var glass_block_scene: PackedScene
@export var laser_scene: PackedScene
@export var max_health: int = 3  # Max hearts
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

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
	if is_paused_for_attack:
		return
	
	position.x = x_position
	
	var target_y = player.global_position.y
	global_position.y = lerp(global_position.y, target_y, 10 * delta)

func start_attack_cycle():
	is_paused_for_attack = true
	$AttackTimer.start(0.5)  # Wait 1 second before shooting block

func throw_glass_block():
	if glass_block_scene:
		$AnimatedSprite2D.play("attack")
		var block = glass_block_scene.instantiate()
		get_parent().add_child(block)
		block.attach_to_boss(self)  # Attach block to boss initially
		# Wait a little, then launch it
		launch_block_later(block)

func launch_block_later(block):
	await get_tree().create_timer(2.0).timeout  # Wait 1 second while attached
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
		block.queue_free()

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

func flash_red() -> void:
	var sprite = $AnimatedSprite2D
	var original_modulate = sprite.modulate
	sprite.modulate = Color(1, 0, 0)  # Full red
	await get_tree().create_timer(0.3).timeout  # Wait 0.1 seconds
	sprite.modulate = original_modulate  # Go back to normal

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.time_slow_cooldown = 1.0
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").play("death")
		
		body.set_physics_process(false)  # stop player movement if needed
		
		if body.has_method("reset_time_slow"):
			body.reset_time_slow()
		
		await get_tree().create_timer(1).timeout  # give the animation time
		get_tree().reload_current_scene()

func _on_attack_timer_timeout() -> void:
	if attack_phase == 0:
		print("Phase 0 start: Throw Block")
		throw_glass_block()
		is_paused_for_attack = false
		attack_phase = 1
		$AttackTimer.start(5.0)  # Wait for block to launch before firing laser
	elif attack_phase == 1:
		print("Phase 1 start: Fire Laser")
		$AnimatedSprite2D.play("charge")
		await get_tree().create_timer(2.0).timeout
		fire_laser()
		is_paused_for_attack = false
		attack_phase = 0  # Reset back to Phase 0
		$AnimatedSprite2D.play("fly") 
		$AttackTimer.start(3)  # Small delay before starting overand this)

func die():
	print("Boss defeated!")
	is_dead = true
	PlayerState.slow_unlocked = false
	
	for coconut in get_tree().get_nodes_in_group("GlassBlocks"):
		coconut.queue_free()
	
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.is_time_slowed:
		player.reset_time_slow()
	
	if is_dead == true:
		var sprite = $AnimatedSprite2D
		sprite.play("death")  # Play the death animation
		await get_tree().create_timer(2).timeout  # Wait until animation is done
	queue_free()  # Delete boss after death animation

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lasers"):
		print("Laser Hit!")
		flash_red()
		take_damage()
