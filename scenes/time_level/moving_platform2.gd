extends CharacterBody2D

@export var speed: float = 250.0
@export var top_limit: float = -200.0
@export var bottom_limit: float = 0.0

var direction := 1
var start_y := 0.0
var frozen := false
var player_on_platform := false
var is_hovered := false

var HandPointer = load("res://assets/sprites/cursor/Hand Pointer.png")
var Pointer = load("res://assets/sprites/cursor/Pointer.png")

func _ready():
	start_y = position.y
	
	# Connect mouse input and hover signals
	$Area2D.connect("input_event", _on_area_input)
	$Area2D.connect("mouse_entered", _on_mouse_entered)
	$Area2D.connect("mouse_exited", _on_mouse_exited)

	update_highlight()

func _physics_process(delta):
	if frozen:
		return

	position.y += direction * speed * delta
	if position.y < start_y + top_limit:
		direction = 1
	elif position.y > start_y + bottom_limit:
		direction = -1

func _on_area_input(viewport, event, shape_idx):
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

func update_highlight():
	if frozen:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color.YELLOW
	elif is_hovered:
		$HighlightSprite2D.visible = true
		$HighlightSprite2D.modulate = Color(1, 1, 1, 0.5)  # white-ish semi-glow
	else:
		$HighlightSprite2D.visible = false
