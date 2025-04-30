extends TextureRect

@onready var anim = $Cutscene/ColorRect/AnimationPlayer

var is_cutscene = false
var has_player_entered_area = false
var player = null

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("Player"):
		player = body
		if !has_player_entered_area:
			has_player_entered_area = true
			cutscene()
			
func cutscene():
	is_cutscene = true
	anim.play("open")
