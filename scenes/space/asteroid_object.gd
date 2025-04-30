extends RigidBody2D

@export var respawn_time: float = 5.0
@export var move_threshold: float = 10.0

var original_position: Vector2
var has_moved := false
var respawn_timer: Timer

func _ready():
	await get_tree().process_frame  # Ensure the position is set by the scene first
	original_position = global_position

	respawn_timer = Timer.new()
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_on_respawn_timeout)
	add_child(respawn_timer)

func _physics_process(_delta):
	if not has_moved and global_position.distance_to(original_position) > move_threshold:
		has_moved = true
		respawn_timer.start()

func _on_respawn_timeout():
	# Fully reset the asteroid's position and motion
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	global_position = original_position
	has_moved = false
