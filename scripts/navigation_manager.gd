extends Node

const scene_tutorial1 = preload("res://scenes/tutorial/tutorial_1.tscn")
const scene_tutorial2 = preload("res://scenes/tutorial/tutorial_2.tscn")
const scene_tutorial3 = preload("res://scenes/tutorial/tutorial_3.tscn")
const scene_tutorial5 = preload("res://scenes/tutorial/turtrial_5.tscn")

const scene_timestart = preload("res://scenes/time_level/timelevel_start.tscn")
const scene_time2 = preload("res://scenes/time_level/time_level_2.tscn")

const scene_end = preload("res://scenes/end.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	print(level_tag)
	match level_tag:
		"tutorial_1":
			scene_to_load = scene_tutorial1
		"tutorial_2":
			scene_to_load = scene_tutorial2
		"tutorial_3":
			scene_to_load = scene_tutorial3
		"tutorial_5":
			scene_to_load = scene_tutorial5
		"time_start":
			scene_to_load = scene_timestart
		"time_level2":
			scene_to_load = scene_time2
		"end":
			scene_to_load = scene_end
		
	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)	
		
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)

# code from Soma Animus https://www.youtube.com/watch?v=3AdAnxrZWGo
