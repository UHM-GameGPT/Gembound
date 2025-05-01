extends Node

@onready var animation = $Portal
@onready var portal := $Portal
@onready var door := $Door_E2

var is_unlocked := false

func _ready():
	$Portal.visible = false
	$Door_E2.monitoring = false
	$Door_E2/CollisionShape2D.disabled = true
	
	door.set_deferred("monitoring", false)  # Prevent collision/interaction

func unlock_portal():
	$Portal.visible = true
	$Door_E2.visible = true
	door.monitoring = true
	$Door_E2/CollisionShape2D.disabled = false
	# portal.global_position = door.global_position  # Align portal with door
	door.set_deferred("monitoring", true)
	if portal.has_method("play"):
		portal.play("portal_open")  # Play portal animation if exists
	is_unlocked = true
