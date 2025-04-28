extends TextureRect
@onready var gemlabel: Label = $gemlabel
@onready var time_gem_1 = $time_gem1

func _ready():
	#coconutbutton.disabled = true
	AudioManager.play_music_tutorial()
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

	print(GemManager.collected_gems.has("gem_time1"))	
	if GemManager.collected_gems.has("gem_time1"):
		time_gem_1.visible = true
		
		gemlabel.text = str(GemManager.collected_gems.size() - 1) + "/6"
	
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func _on_spike_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body is Player:
		body.die()
