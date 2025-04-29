extends CharacterBody2D

@export var fall_speed: float = 100.0

var splatting = false
var has_splatted = false  # To prevent multiple splats

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("fall")

func _physics_process(delta):
	if splatting:
		velocity = Vector2.ZERO  # Stop moving if splatting
	else:
		velocity = Vector2(0, fall_speed)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
	
	elif body.name == "FloorArea":
		splat()

func splat():
	if has_splatted:
		return  # Already splatted
	has_splatted = true
	splatting = true
	# Properly disconnect the body_entered signal
	if $Area2D.has_node("CollisionShape2D"):
		$Area2D.get_node("CollisionShape2D").call_deferred("set_disabled", true)

	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("splat")
	
	position.y -= 10
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("splat")
	await get_tree().create_timer(1).timeout
	queue_free()
