extends TextureRect

@onready var gem_counter: GemCounter = $GemCounter

func _ready():
	AudioManager.play_music_finalboss()
	$Player.can_move = false
	$Player.get_node("AnimatedSprite2D").play("walk_right")

	var tween = create_tween()
	var target_pos = $Player.global_position + Vector2(60, 0)  # Walk right by 50 pixels
	tween.tween_property($Player, "global_position", target_pos, 1.5)  # Over 1.5 seconds

	await tween.finished
	$Player.get_node("AnimatedSprite2D").play("idle_right")
	# Boss entrance
	var boss_sprite = $final_boss_intro_scene.get_node("AnimatedSprite2D")
	boss_sprite.flip_h = true
	boss_sprite.play("fly")

	var boss_start = $final_boss_intro_scene.global_position
	var boss_end = boss_start - Vector2(100, 0)

	var boss_tween = create_tween()
	boss_tween.tween_property($final_boss_intro_scene, "global_position", boss_end, 2.0)

	await boss_tween.finished
	
	await get_tree().create_timer(3.0).timeout  # Wait 3 seconds

	$Text.visible = false  # Hide the first text
	
	await get_tree().create_timer(3.0).timeout  # Wait 3 seconds
	
	$Text2.visible = false  # Hide the first text
	
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/final_boss/final_boss_phase1.tscn")
	
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	
	gem_counter.countgems()
	
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	# NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func _on_spike_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body is Player:
		body.die()
