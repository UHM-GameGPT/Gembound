extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $PauseTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("drop_in")
	anim.animation_finished.connect(_on_animation_finished)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "drop_in":
		timer.start()  # wait 1 second before dropping out

func _on_timer_timeout() -> void:
	anim.play("drop_out")
