extends CharacterBody2D

@export var speed: float = 50.0
@export var top_limit: float = -50.0
@export var bottom_limit: float = 50.0

var direction := 1
var start_y := 0.0
var frozen := false
var player_on_platform := false
var is_hovered := false

func _ready():
	start_y = position.y
	
	# Connect mouse input and hover signals
	$Area2D.connect("input_event", _on_area_input)
	$Area2D.connect("mouse_entered", _on_mouse_entered)
	$Area2D.connect("mouse_exited", _on_mouse_exited)
	
	# Connect player collision signals
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

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

		if not frozen and player_on_platform:
			fade_and_destroy()

func _on_body_entered(body):
	if body.name == "Player":
		player_on_platform = true
		if not frozen:
			fade_and_destroy()

func _on_body_exited(body):
	if body.name == "Player":
		player_on_platform = false

func _on_mouse_entered():
	is_hovered = true
	update_highlight()

func _on_mouse_exited():
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

func fade_and_destroy():
	frozen = true  # lock movement
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true

	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.5)

	if $HighlightSprite2D.visible:
		tween.tween_property($HighlightSprite2D, "modulate:a", 0.0, 0.5)

	await tween.finished
	queue_free()
