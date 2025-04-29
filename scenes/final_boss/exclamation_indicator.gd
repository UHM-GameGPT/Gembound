extends Node2D

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("idle")
