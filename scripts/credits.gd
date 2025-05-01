extends Control

var titleScene = preload("res://scenes/title_screen/title_screen.tscn")

func _ready():
	GemManager.collected_gems.clear()
	PlayerState.dash_unlocked = false
	PlayerState.stop_unlocked = false
	PlayerState.slow_unlocked = false
	PlayerState.clone_unlocked = false
	PlayerState.current_clone = null
	PlayerState.float_unlocked = false

# when the 8 sec timer finishes, changes to the title screen
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(titleScene)
