extends CharacterBody2D

@export var speed: float = 300.0
var direction := Vector2.LEFT
var frozen := false
var is_hovered := false
var is_attached_to_boss: bool = false
var is_breaking = false
var boss_node: Node2D = null  # Store boss reference

var HandPointer = load("res://assets/sprites/cursor/Hand Pointer.png")
var Pointer = load("res://assets/sprites/cursor/Pointer.png")

func _ready():
	$Area2D.input_event.connect(_on_area_input)
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	add_to_group("GlassBlocks")
	update_highlight()

func _physics_process(delta):
	if is_attached_to_boss and boss_node:
		global_position = boss_node.global_position + Vector2(-30, 0)  # Offset a little in front
		velocity = Vector2.ZERO
	elif frozen:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed
	move_and_slide()

func _on_area_input(viewport, event, shape_idx):
	if is_attached_to_boss:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		frozen = !frozen
		update_highlight()

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(HandPointer, Input.CURSOR_ARROW)
	is_hovered = true
	update_highlight()

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(Pointer, Input.CURSOR_ARROW)
	is_hovered = false
	update_highlight()

func is_frozen() -> bool:
	return frozen

func update_highlight():
	if is_attached_to_boss:
		$HighlightSprite2D.visible = false
		return
	if frozen:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color.YELLOW
	elif is_hovered:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color(1, 1, 1, 0.5) # subtle white glow
	else:
		$HighlightSprite2D.visible = false

func break_and_destroy():
	if is_breaking:
		return
	is_breaking = true

	# Turn off highlight if visible
	if has_node("HighlightSprite2D"):
		$HighlightSprite2D.visible = false
	
	if has_node("Sprite2D"):
		$Sprite2D.visible = false

	# Play breaking animation
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("breaking")

	await get_tree().create_timer(0.7).timeout  # Match to breaking animation length
	queue_free()

func attach_to_boss(boss: Node2D):
	is_attached_to_boss = true
	boss_node = boss

func launch():
	is_attached_to_boss = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not frozen and body.name == "Player":
		body.die()
