extends CharacterBody2D

@export var speed: float = 40.0
var direction := Vector2.LEFT
var frozen := false
var is_hovered := false

func _ready():
	$Area2D.input_event.connect(_on_area_input)
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	update_collision_state()
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
		update_collision_state()
		update_highlight()

func _on_mouse_entered():
	is_hovered = true
	update_highlight()

func _on_mouse_exited():
	is_hovered = false
	update_highlight()

func update_collision_state():
	$CollisionShape2D.disabled = not frozen

func update_highlight():
	if frozen:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color.YELLOW
	elif is_hovered:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color(1, 1, 1, 0.5) # subtle white glow
	else:
		$HighlightSprite2D.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not frozen and body.name == "Player":
		body.time_slow_cooldown = 1.0
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").play("death")
		
		body.set_physics_process(false)  # stop player movement if needed
		
		if body.has_method("reset_time_slow"):
			body.reset_time_slow()
			
		await get_tree().create_timer(1).timeout  # give the animation time
		get_tree().reload_current_scene()
