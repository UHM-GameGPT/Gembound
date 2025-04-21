extends PathFollow2D

var speed = 0.15

func _process(delta: float) -> void:
	loop_movement(delta)
	
func loop_movement(delta):
	progress_ratio += delta * speed
