extends Area2D

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

func _on_body_entered(body):
	if body.has_method("reset_time_slow"):
		body.time_slow_cooldown = 1.0
		body.reset_time_slow()

	if body is Player:
		if PlayerState.stop_unlocked:
			NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
		else:
			show_locked_message()

func show_locked_message():
	var message_node = get_tree().get_root().get_node("TimeLevelStart/LockedMessage")
	var anim = message_node.get_node("AnimationPlayer")

	if anim:
		message_node.visible = true
		anim.play("show_tutorial")
		await get_tree().create_timer(2.0).timeout
		message_node.visible = false
