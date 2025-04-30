extends CharacterBody2D

@export var fall_speed := 1000.0
@export var float_speed := 50.0
@export var max_float_height := 10.0
@export var linger_time := 6.0

var is_falling := true
var is_grounded := false
var is_floating := false
var is_hovered := false
var start_y := 0.0

func _ready():
	add_to_group("Asteroid")
	start_y = global_position.y

	$Area2D.input_event.connect(_on_area_input)
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)

	update_highlight()

func _physics_process(delta):
	if is_falling:
		velocity.y += fall_speed * delta
		move_and_slide()

	elif is_floating:
		if global_position.y > max_float_height:
			velocity.y = -float_speed
			move_and_slide()
		else:
			global_position.y = max_float_height  # Snap to float height
			velocity = Vector2.ZERO

	if is_on_floor() and not is_grounded:
		is_grounded = true
		is_falling = false
		start_linger_timer()

	update_highlight()

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_floating:
			is_falling = false
			is_floating = true
		else:
			is_floating = false
			is_falling = true

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false

func update_highlight():
	if is_hovered or is_floating:
		$HighlightSprite2D.visible = true
	else:
		$HighlightSprite2D.visible = false

func start_linger_timer():
	await get_tree().create_timer(linger_time).timeout
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_falling and body.name == "Player":
		body.die()
