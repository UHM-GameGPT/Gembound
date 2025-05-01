extends TextureRect
@onready var gem_counter: GemCounter = $GemCounter

func _ready():
	AudioManager.play_music_spacelevel()
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	
	gem_counter.countgems()
		
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
