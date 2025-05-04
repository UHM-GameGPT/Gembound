extends Node2D

var current_player = null

func _ready():
	$time_gem_2.body_entered.connect(_play_animation)
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _play_animation(body):
	$time_gem_2.body_entered.disconnect(_play_animation)

	if body.name == "Player":
		body.can_move = false
		current_player = body
	
	$AnimationPlayer.play("show_tutorial")
	
	await get_tree().create_timer(3.0).timeout  # Wait 3 seconds

	$Text.visible = false

func _on_animation_finished(anim_name: String):
	if anim_name == "show_tutorial" and current_player:
		current_player.can_move = true
		current_player = null
