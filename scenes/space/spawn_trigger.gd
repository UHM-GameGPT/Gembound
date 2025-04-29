extends Area2D

func _on_body_entered(body: Node2D):
	var spawner = get_node("/root/SpaceMiniBoss/AsteroidContainer/AsteroidSpawner")
	spawner.spawn_asteroid()
