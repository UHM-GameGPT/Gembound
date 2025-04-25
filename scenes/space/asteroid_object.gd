extends RigidBody2D

@export var respawn_time: float = 5.0
@export var move_threshold: float = 10.0  # Adjust as needed

var original_position: Vector2
var has_moved = false
var respawn_timer: Timer

func _ready():
	original_position = global_position

	respawn_timer = Timer.new()
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_on_respawn_timeout)
	add_child(respawn_timer)

	print("Timer added with wait_time =", respawn_timer.wait_time)

func _physics_process(_delta):
	var dist = global_position.distance_to(original_position)
	print("Distance from original:", dist)

	if not has_moved and dist > move_threshold:
		print("Asteroid moved! Distance =", dist)
		has_moved = true
		respawn_timer.start()
		print("Respawn timer started!")

func _on_respawn_timeout():
	print("Respawning asteroid.")
	global_position = original_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	has_moved = false
