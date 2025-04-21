extends TextureRect

@onready var animated_sprite: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var timer: Timer = $Timer

var angle:float = 0.0
var speed:float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	AudioManager.play_music_tutorial()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
