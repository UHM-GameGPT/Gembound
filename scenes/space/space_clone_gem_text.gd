extends Node2D

var current_player = null

func _ready():
	$SpaceCloneGem.body_entered.connect(_play_animation)
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _play_animation(body):
	$SpaceCloneGem.body_entered.disconnect(_play_animation)

	if body is Player:
		body.can_move = false
		current_player = body
	
	$AnimationPlayer.play("show_tutorial")

func _on_animation_finished(anim_name: String):
	if anim_name == "show_tutorial" and current_player:
		current_player.can_move = true
		current_player = null
