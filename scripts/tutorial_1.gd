extends TextureRect

func _ready():
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
		
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)


#func _on_platform_scene_detection_body_entered(body):
#	if body is Player:
#		get_tree().change_scene_to_file("res://scenes/tutorial/tutorial_2.tscn")
