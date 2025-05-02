extends Node

@onready var animation = $Portal
@onready var portal = $Portal
@onready var door = $Door_E2

var is_unlocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal.visible = false
	door.visible = false
	door.monitoring = false
	$Door_E2/CollisionShape2D.disabled = true
	door.set_deferred("monitoring", false)  # Prevent collision/interaction

func unlock_portal():
	portal.visible = true
	door.visible = true
	door.monitoring = true
	$Door_E2/CollisionShape2D.disabled = false
	door.set_deferred("monitoring", true)
	if portal.has_method("play"):
		portal.play("portal_open")
	is_unlocked = true
