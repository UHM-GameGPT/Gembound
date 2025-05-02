extends Node2D

func _ready():
	await get_tree().create_timer(7.0).timeout
	$AnimationPlayer.play("show_tutorial")
