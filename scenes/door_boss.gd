extends Area2D

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn
@onready var door_collision = $CollisionShape2D

func _ready():
	visible = false # Start the door as invisible
	door_collision.disabled = true  # Disable until boss dies
	
func open():
	print("Opening the boss door!")  # debug
	visible = true
	door_collision.disabled = false  # Enable collision detection
	
func _on_body_entered(body):
	if body.has_method("reset_time_slow"):
			body.time_slow_cooldown = 1.0
			body.reset_time_slow()
	if body is Player:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)

func _on_area_entered(area):
	if area.name == "Player":
		if get_parent().is_unlocked:
			print("Door entered. Transitioning...")
			NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
		else:
			print("Door is locked. Defeat the boss!")
