extends Node2D

func _ready():
	$AnimationPlayer.play("show_tutorial")

func hide_message():
	$Label.visible = false
