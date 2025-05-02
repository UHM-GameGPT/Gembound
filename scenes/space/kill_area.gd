extends Area2D

@onready var collider = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()

func _on_pressure_plate_activated() -> void:
	collider.call_deferred("set_disabled", true)

func _on_pressure_plate_deactivated() -> void:
	collider.call_deferred("set_disabled", false)
