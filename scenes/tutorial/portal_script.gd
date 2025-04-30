extends Node

@onready var animation = $AnimatedSprite2D

func _ready():
	# Play portal_open once
	animation.play("portal_open")
	# Connect to the animation_finished signal
	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String):
	if anim_name == "portal_open":
		# Now play portal_idle in a loop
		animation.play("portal_idle")
