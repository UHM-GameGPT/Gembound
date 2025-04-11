extends RigidBody2D

@export var custom_gravity_scale: float = 0.2
var should_respawn: bool = true

func _ready():
	gravity_scale = custom_gravity_scale

func _on_land():
	queue_free()  # Coconut destroys itself when hitting the ground

func set_should_respawn(value: bool):
	should_respawn = value
