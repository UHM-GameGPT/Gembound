extends Control
var HandPointer = load("res://assets/sprites/cursor/Hand Pointer.png")
var Pointer = load("res://assets/sprites/cursor/Pointer.png")

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


func _on_play_button_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(HandPointer, Input.CURSOR_ARROW)

func _on_play_button_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(Pointer, Input.CURSOR_ARROW)


func _on_exit_button_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(HandPointer, Input.CURSOR_ARROW)

func _on_exit_button_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(Pointer, Input.CURSOR_ARROW)
