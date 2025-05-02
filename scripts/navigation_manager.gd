extends Node

const scene_tutorial1 = preload("res://scenes/tutorial/tutorial_1.tscn")
const scene_tutorial2 = preload("res://scenes/tutorial/tutorial_2.tscn")
const scene_tutorial3 = preload("res://scenes/tutorial/tutorial_3.tscn")
const scene_tutorial5 = preload("res://scenes/tutorial/tutorial_5.tscn")
const scene_tutorial6 = preload("res://scenes/tutorial/tutorial_6.tscn")

const scene_timestart = preload("res://scenes/time_level/timelevel_start.tscn")
const scene_time2 = preload("res://scenes/time_level/time_level_2.tscn")
const scene_time3 = preload("res://scenes/time_level/time_level_3.tscn")
const scene_time4 = preload("res://scenes/time_level/time_level_4.tscn")
const scene_time5 = preload("res://scenes/time_level/time_level_5.tscn")
const scene_time6 = preload("res://scenes/time_level/time_level_6.tscn")
const scene_time7 = preload("res://scenes/time_level/time_level_7.tscn")
const scene_time_boss = preload("res://scenes/time_level/time_level_boss.tscn")

const scene_space1 = preload("res://scenes/space/space_1.tscn")
const scene_space2 = preload("res://scenes/space/space_2.tscn")
const scene_space3 = preload("res://scenes/space/space_3.tscn")
const scene_space4 = preload("res://scenes/space/space_4.tscn")
const scene_space5 = preload("res://scenes/space/space_5.tscn")
const scene_space6 = preload("res://scenes/space/space_6.tscn")
const scene_space7 = preload("res://scenes/space/space_7.tscn")

const final_boss_intro = preload("res://scenes/final_boss/final_boss_intro.tscn")
const final_boss_phase1 = preload("res://scenes/final_boss/final_boss_phase1.tscn")
const final_boss_phase2 = preload("res://scenes/final_boss/final_boss_phase2.tscn")
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
		"tutorial_6":
			scene_to_load = scene_tutorial6
		"time_start":
			scene_to_load = scene_timestart
		"time_level2":
			scene_to_load = scene_time2
		"time_level3":
			scene_to_load = scene_time3
		"time_level4":
			scene_to_load = scene_time4
		"time_level5":
			scene_to_load = scene_time5
		"time_level6":
			scene_to_load = scene_time6
		"time_level7":
			scene_to_load = scene_time7
		"time_level_boss":
			scene_to_load = scene_time_boss
		"space_1":
			scene_to_load = scene_space1
		"space_2":
			scene_to_load = scene_space2
		"space_3":
			scene_to_load = scene_space3
		"space_4":
			scene_to_load = scene_space4
		"space_5":
			scene_to_load = scene_space5
		"space_6":
			scene_to_load = scene_space6
		"space_7":
			scene_to_load = scene_space7
		"final_boss_intro":
			scene_to_load = final_boss_intro
		"final_boss_phase1":
			scene_to_load = final_boss_phase1
		"final_boss_phase2":
			scene_to_load = final_boss_phase2
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
