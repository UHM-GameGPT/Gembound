extends AnimatableBody2D

class_name TimePlatform2

var timer_time_wait: float = 5.0

func slowdown(skill: String, factor: float):
	match skill:
		"stop":
			pass
