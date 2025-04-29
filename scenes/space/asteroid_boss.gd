extends RigidBody2D

@export var float_distance := 100.0
@export var float_speed := 100.0

var is_floating := false
var float_direction := Vector2.ZERO

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	print("asteroid ready")


func _integrate_forces(state):
	if is_floating:
		position += float_direction * float_speed * state.step
		if position.y < 0:  # off-screen
			queue_free()

func _on_body_entered(body):
	if body.name == "Ground":
		queue_free()

func trigger_float():
	if not is_floating:
		is_floating = true
		gravity_scale = 0
		float_direction = Vector2(0, -1)
