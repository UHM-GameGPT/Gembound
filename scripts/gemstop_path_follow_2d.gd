extends PathFollow2D

@onready var animation_player: AnimationPlayer = $"../../gauntlet/AnimationPlayer"

var speed = 0.25

func _process(delta: float) -> void:
	loop_movement(delta)
	
func loop_movement(delta):
	progress_ratio += delta * speed	
