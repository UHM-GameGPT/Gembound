extends StaticBody2D

@export var float_height: float = 100
@export var float_speed: float = 50
@export var requires_gem: bool = true
@onready var outline = $OutlineSprite2D
@onready var click_area = $ClickArea

var start_position: Vector2
var target_position: Vector2
var is_floating = false
var going_up = true

func _ready():
	start_position = global_position
	target_position = start_position - Vector2(0, float_height)
	click_area.mouse_entered.connect(_on_mouse_entered)
	click_area.mouse_exited.connect(_on_mouse_exited)
	click_area.input_event.connect(_on_click)
	outline.visible = false
	$ClickArea.input_event.connect(_on_click)

func _on_mouse_entered():
	if not is_floating and (not requires_gem or PlayerState.float_unlocked):
		outline.visible = true

func _on_mouse_exited():
	outline.visible = false

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and not is_floating:
		if not requires_gem or PlayerState.float_unlocked:
			is_floating = true
			going_up = true  # Start floating upward

func _physics_process(delta):
	if is_floating:
		var destination = target_position if going_up else start_position
		global_position = global_position.move_toward(destination, float_speed * delta)

		if global_position.distance_to(destination) < 1:
			global_position = destination  # Snap to target
			going_up = not going_up
