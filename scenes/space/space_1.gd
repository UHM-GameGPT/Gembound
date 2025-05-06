extends TextureRect
@onready var gem_counter: Space_GemCounter = $Space_GemCounter

var Pointer = load("res://assets/sprites/cursor/Pointer.png")

func _ready():
	Input.set_custom_mouse_cursor(Pointer, Input.CURSOR_ARROW)
	AudioManager.play_music_spacelevel()
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	
	gem_counter.countgems()
	
	$Player.can_move = false
	$Player.get_node("AnimatedSprite2D").play("idle_right")
	await get_tree().create_timer(2).timeout
	$Player.can_move = true
	
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func _on_spike_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body is Player:
		body.die()
