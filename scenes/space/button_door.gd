extends Node2D

func open():
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")

func close():
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("close")
