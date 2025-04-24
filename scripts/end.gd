extends TextureRect

@onready var animated_sprite: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $gauntlet/AnimationPlayer
@onready var gemstop_path: PathFollow2D = $GemstopPath2D/GemstopPathFollow2D
@onready var gemdash_path: PathFollow2D = $GemdashPath2D/GemdashPathFollow2D
@onready var gemclone_path: PathFollow2D = $GemclonePath2D/GemclonePathFollow2D

var creditsScene = preload("res://scenes/credits.tscn")

var angle:float = 0.0
var speed:float = 1.5
var anim_played:bool = false
var gemstopfinished: bool = false
var gemdashfinished: bool = false
var gemclonefinished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	AudioManager.play_music_tutorial()
	
func _process(delta: float) -> void:
	checkfinished()
	#print(gemclone_path.progress_ratio)
	
func checkfinished():
	print(gemclonefinished)
	if gemstop_path.progress_ratio >= 0.84:
		gemstopfinished = true
	
	if gemdash_path.progress_ratio >= 0.845:
		gemdashfinished = true
	
	if gemclone_path.progress_ratio >= 0.78:
		gemclonefinished = true
	
	if gemstopfinished and gemdashfinished and gemclonefinished and not anim_played:
		animation_player.play("topdown")

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(creditsScene)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_played = true
