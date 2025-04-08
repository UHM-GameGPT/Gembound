extends Control

# when the 15 sec timer finishes, changes to the title screen
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen/title_screen.tscn")
