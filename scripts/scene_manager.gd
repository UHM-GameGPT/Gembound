extends Node

var reload_timer: Timer

func _ready():
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	add_child(reload_timer)
	reload_timer.timeout.connect(_on_reload_timeout)

func reload_scene_after_delay(delay: float):
	reload_timer.start(delay)

func _on_reload_timeout():
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)
