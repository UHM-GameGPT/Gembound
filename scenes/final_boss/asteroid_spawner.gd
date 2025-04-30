extends Node2D

@export var asteroid_scene: PackedScene
@export var warning_scene: PackedScene
@export var drop_height := -200.0  # Offset from warning

func spawn_asteroid(position: Vector2):
	# 1. Show warning
	var warning = warning_scene.instantiate()
	warning.global_position = position
	get_tree().current_scene.add_child(warning)

	# 2. Wait for the warning's lifetime, then drop asteroid
	await get_tree().create_timer(1.2).timeout

	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = position + Vector2(0, drop_height)
	get_tree().current_scene.add_child(asteroid)
