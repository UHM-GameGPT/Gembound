extends TextureRect

func _on_platform_scene_detection_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/tutorial/tutorial_2.tscn")
