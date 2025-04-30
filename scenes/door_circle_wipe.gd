extends Area2D

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn
@onready var anim = $ColorRect/AnimationPlayer

func _on_body_entered(body):
	if body.has_method("reset_time_slow"):
			body.time_slow_cooldown = 1.0
			body.reset_time_slow()
	if body is Player:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
