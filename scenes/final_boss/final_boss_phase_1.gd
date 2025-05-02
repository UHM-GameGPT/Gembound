extends TextureRect

@onready var gem_counter: GemCounter = $GemCounter

func _ready():
	gem_counter.countgems()
	
	AudioManager.play_music_finalboss()
	await get_tree().create_timer(3.0).timeout
	$Text.visible = false  
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	# NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func _on_spike_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body is Player:
		body.die()
