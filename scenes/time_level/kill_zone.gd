extends Area2D

@export var coconut_scene: PackedScene
@export var spawn_point: NodePath


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Coconuts"):
		body.break_apart()
