extends CharacterBody2D

@export var speed: float = 120.0
var direction := Vector2.LEFT
var frozen := false
var is_hovered := false

func _ready():
	$Area2D.input_event.connect(_on_area_input)
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	add_to_group("Coconuts")
	update_highlight()

func _physics_process(delta):
	if frozen:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed

	move_and_slide()

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		frozen = !frozen
		update_highlight()

func _on_mouse_entered():
	is_hovered = true
	update_highlight()

func _on_mouse_exited():
	is_hovered = false
	update_highlight()

func is_frozen() -> bool:
	return frozen

func update_highlight():
	
	if frozen:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color.YELLOW
	elif is_hovered:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color(1, 1, 1, 0.5) # subtle white glow
	else:
		$HighlightSprite2D.visible = false

func break_apart():
	
	frozen = true  # Stop motion logic
	is_hovered = false
	velocity = Vector2.ZERO  # Stop current velocity
	set_physics_process(false)  # Disable _physics_process entirely
	
	if $Area2D.mouse_entered.is_connected(_on_mouse_entered):
		$Area2D.mouse_entered.disconnect(_on_mouse_entered)
	if $Area2D.mouse_exited.is_connected(_on_mouse_exited):
		$Area2D.mouse_exited.disconnect(_on_mouse_exited)
	
	$Sprite2D.visible = false
	$HighlightSprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("break")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not frozen and body.name == "Player":
		if body.has_method("die"):
			body.die()
