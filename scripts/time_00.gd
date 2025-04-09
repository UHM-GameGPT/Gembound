extends TextureRect

#platform 2
@onready var platform2btn: TextureButton = $Platforms/TimePlatform2/platform2btn
@onready var timeplatform_2: AnimationPlayer = $Platforms/TimePlatform2/timeplatform2
@onready var platform_2_timer: Timer = $Platforms/TimePlatform2/timeplatform2/platform2timer

#platform 3
@onready var platform3btn: TextureButton = $Platforms/TimePlatform3/platform3btn
@onready var timeplatform_3: AnimationPlayer = $Platforms/TimePlatform3/timeplatform3
@onready var platform_3_timer: Timer = $Platforms/TimePlatform3/timeplatform3/platform3timer

var activeSkill: String

func _ready() -> void:
	platform2btn.disabled = true
	platform3btn.disabled = true

func _on_platform_2_btn_pressed() -> void:
	print("clicked platform 2 button")
	platform_2_timer.start(5.0)
	match activeSkill:
		"stop":
			timeplatform_2.speed_scale = 0.0
		"slow":
			timeplatform_2.speed_scale = 0.25

func _on_timer_timeout() -> void:
	timeplatform_2.speed_scale = 1.0

func _on_stop_pressed() -> void:
	print("clicked stop button")
	activeSkill = "stop"
	platform2btn.disabled = false
	platform3btn.disabled = false

func _on_slow_pressed() -> void:
	print("clicked slow button")
	activeSkill = "slow"
	platform2btn.disabled = false
	platform3btn.disabled = false


func _on_platform_3_btn_pressed() -> void:
	print("clicked platform 3 button")
	platform_3_timer.start(2.0)
	match activeSkill:
		"stop":
			timeplatform_3.speed_scale = 0.0
		"slow":
			timeplatform_3.speed_scale = 0.25
			
func _on_platform_3_timer_timeout() -> void:
	timeplatform_3.speed_scale = 1.0
