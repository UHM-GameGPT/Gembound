extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $Player/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("jumping")
	pass
	
