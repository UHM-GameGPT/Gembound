extends Node

@onready var animation = $Portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("portal_close")
