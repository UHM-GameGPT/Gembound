extends Area2D

@export var coconut_scene: PackedScene
@export var spawn_point: NodePath


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Coconut":
		var do_respawn = true
		if body.has_method("get"):
			do_respawn = body.should_respawn

		body.queue_free()

		if do_respawn:
			await get_tree().create_timer(1.0).timeout
			spawn_new_coconut()

func spawn_new_coconut():
	var new_coconut = coconut_scene.instantiate()
	var parent = get_tree().current_scene
	parent.add_child(new_coconut)
	
	var spawn = get_node(spawn_point)
	new_coconut.global_position = spawn.global_position
	
func _on_enemy_spirit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
