extends TextureRect
@onready var gem_counter: GemCounter = $GemCounter
@onready var boss = $MiniBoss
@onready var doors = $Doors

var Pointer = load("res://assets/sprites/cursor/Pointer.png")

func _ready():
	Input.set_custom_mouse_cursor(Pointer, Input.CURSOR_ARROW)
	#coconutbutton.disabled = true
	AudioManager.play_music_timelevel()
	if boss:
		boss.boss_died.connect(_on_boss_died)
	if NavigationManager.spawn_door_tag !=null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	
	gem_counter.countgems()
	
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	
func _on_spike_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
	if body is Player:
		body.die()
		
func _on_boss_died():
	print("Boss defeated! Unlocking portal...")
	doors.unlock_portal()
