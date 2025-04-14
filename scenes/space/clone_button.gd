extends Area2D

@export var requires_weight := true
@export var activate_once := false
var is_active := false
var objects_on_plate := 0

signal plate_activated
signal plate_deactivated

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node):
	if body.is_in_group("weights"):
		objects_on_plate += 1
		if not is_active:
			is_active = true
			$AnimatedSprite2D.play("pressed")
			emit_signal("plate_activated")

func _on_body_exited(body: Node):
	if body.is_in_group("weights"):
		objects_on_plate -= 1
		if objects_on_plate <= 0:
			is_active = false
			$AnimatedSprite2D.play("idle")
			emit_signal("plate_deactivated")
