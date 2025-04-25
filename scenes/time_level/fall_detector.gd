extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.time_slow_cooldown = 1.0
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").play("death")
		
		# Stop the player from moving
		body.set_physics_process(false)

		# ✅ Reset time slow if active
		if body.has_method("reset_time_slow"):
			body.reset_time_slow()

		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
