extends Node2D

@export var move_speed := 60.0
@export var top_y := 30.0
@export var bottom_y := 140.0
@export var offscreen_y := -100.0
@export var right_x := 300.0
@export var left_x := 20.0
@export var coconut_scene: PackedScene  # This should now point to miniboss_coconuts.tscn
@export var throw_interval := 2.0

enum State { ENTERING, PAUSING, PATROLLING, EXITING, SWITCHING_SIDE }
var state = State.ENTERING

var vertical_direction := 1
var current_side := "right"

var throw_timer := 0.0

var health := 3
var heart_nodes := []

func _ready():
	global_position = Vector2(right_x, offscreen_y)
	# Cache the heart UI nodes
	var ui = get_tree().current_scene.get_node("CanvasLayer/BossHearts")
	heart_nodes = ui.get_children()
	update_hearts()
	
	randomize()
	global_position = Vector2(right_x, offscreen_y)
	set_process(true)

func _process(delta):
	match state:
		State.ENTERING:
			global_position.y += move_speed * delta
			if global_position.y >= top_y:
				global_position.y = top_y
				state = State.PAUSING
				start_pause()
		State.PAUSING:
			# Do nothing — waiting during coroutine
			pass
		State.PATROLLING:
			global_position.y += vertical_direction * move_speed * delta
			if global_position.y >= bottom_y:
				vertical_direction = -1
			elif global_position.y <= top_y:
				vertical_direction = 1
				state = State.EXITING
			throw_timer -= delta
			if throw_timer <= 0:
				throw_coconut()
				throw_timer = randf_range(1.0, 2.0)

		State.EXITING:
			global_position.y -= move_speed * delta
			if global_position.y <= offscreen_y:
				state = State.SWITCHING_SIDE
		State.SWITCHING_SIDE:
			current_side = "left" if current_side == "right" else "right"
			global_position.x = left_x if current_side == "left" else right_x
			# Flip the sprite to face the direction it's flying
			$AnimatedSprite2D.flip_h = (current_side == "left")

			state = State.ENTERING

func throw_coconut():
	if coconut_scene == null:
		return

	var coconut = coconut_scene.instantiate()
	# Position it to the left or right of the boss
	var offset = Vector2(30, 0)
	offset.x = -offset.x if current_side == "right" else offset.x
	coconut.global_position = global_position + offset

	# Set direction, if your miniboss_coconuts.gd has a `direction` variable
	coconut.direction = Vector2.LEFT if current_side == "right" else Vector2.RIGHT

	get_parent().add_child(coconut)

func start_pause():
	await get_tree().create_timer(1.0).timeout
	state = State.PATROLLING

func update_hearts():
	for i in range(heart_nodes.size()):
		heart_nodes[i].visible = i < health

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_variable("frozen") and not body.frozen:
		health -= 1
		body.queue_free()
		update_hearts()

		if health <= 0:
			die()

func die():
	$AnimatedSprite2D.play("death")  # if you have a death animation
	set_process(false)
	await get_tree().create_timer(1.0).timeout
	queue_free()  # or trigger cutscene, etc
