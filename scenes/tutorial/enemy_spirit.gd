extends Area2D

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Log" and body is RigidBody2D:
		print("Log hit the slime!")

		# Optional: stop log from moving
		body.linear_velocity = Vector2.ZERO

		# Wait before deleting (0.3 seconds)
		await get_tree().create_timer(0.3).timeout

		# THEN hide and remove both
		visible = false
		$CollisionShape2D.disabled = true
		queue_free()

		if body.has_node("CollisionShape2D"):
			body.get_node("CollisionShape2D").disabled = true
		body.queue_free()
