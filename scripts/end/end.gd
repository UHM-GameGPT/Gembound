extends TextureRect

@onready var timer: Timer = $Timer

var creditsScene = preload("res://scenes/credits.tscn")

var angle:float = 0.0
var speed:float = 1.5
var anim_played:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	AudioManager.play_music_tutorial()
	
func _process(delta: float) -> void:
	checkfinished()
	#print(gemclone_path.progress_ratio)
	
func checkfinished():
	pass

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(creditsScene)
