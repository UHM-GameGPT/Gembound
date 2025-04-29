extends CharacterBody2D

@export var speed: float = 300.0
var direction := Vector2.LEFT
var frozen := false
var is_hovered := false
var is_attached_to_boss: bool = false
var boss_node: Node2D = null  # Store boss reference

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
	is_hovered = true
	update_highlight()

func _on_mouse_exited():
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

func attach_to_boss(boss: Node2D):
	is_attached_to_boss = true
	boss_node = boss

func launch():
	is_attached_to_boss = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not frozen and body.name == "Player":
		body.die()
