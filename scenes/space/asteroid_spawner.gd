extends Node2D

@export var asteroid_scene: PackedScene

@onready var marker = $Marker2D
@onready var container = get_node("/root/SpaceMiniBoss/AsteroidContainer")

func spawn_asteroid():
	if not asteroid_scene:
		return
	print("Marker global pos:", marker.global_position)

	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = marker.global_position
	container.add_child(asteroid)
	print("Asteroid global pos after add:", asteroid.global_position)
