extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music_tutorial()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen/intro_text.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
