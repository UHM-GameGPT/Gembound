extends TextureRect

class_name TimeZero

#platform 2
@onready var platform2btn: TextureButton = $Platforms/TimePlatform2/platform2btn
@onready var timeplatform_2: AnimationPlayer = $Platforms/TimePlatform2/timeplatform2
@onready var platform_2_timer: Timer = $Platforms/TimePlatform2/timeplatform2/platform2timer

#platform 3
@onready var platform3btn: TextureButton = $Platforms/TimePlatform3/platform3btn
@onready var timeplatform_3: AnimationPlayer = $Platforms/TimePlatform3/timeplatform3
@onready var platform_3_timer: Timer = $Platforms/TimePlatform3/timeplatform3/platform3timer

#platform 4
@onready var platform4btn: TextureButton = $Platforms/TimePlatform4/platform4btn
@onready var timeplatform_4: AnimationPlayer = $Platforms/TimePlatform4/timeplatform4
@onready var platform_4_timer: Timer = $Platforms/TimePlatform4/timeplatform4/platform4timer

var random = RandomNumberGenerator.new()
var activeSkill: String

func _ready() -> void:
	platform2btn.disabled = true
	platform3btn.disabled = true
	platform4btn.disabled = true

func _process(delta: float) -> void:
	if GemManager.collected_gems.has("gem_stoptime"):
		activeSkill = "stop"

func enableButtons() -> void:
	platform2btn.disabled = false
	platform3btn.disabled = false
	platform4btn.disabled = false

func _on_platform_2_btn_pressed() -> void:
	print("clicked platform 2 button")
	
	platform_2_timer.wait_time = random.randf_range(1.0, 5.0)
	platform_2_timer.start()
	
	platform2btn.disabled = true
	set_process(true)
	
	match activeSkill:
		"stop":
			timeplatform_2.speed_scale = 0.0
		"slow":
			timeplatform_2.speed_scale = 0.25

func _on_timer_timeout() -> void:
	timeplatform_2.speed_scale = 1.0
	platform2btn.disabled = false
	set_process(false)

func _on_platform_3_btn_pressed() -> void:
	print("clicked platform 3 button")
	platform3btn.disabled = true
	set_process(true)
	platform_3_timer.wait_time = random.randf_range(1.0, 2.0)
	platform_3_timer.start()
	
	match activeSkill:
		"stop":
			timeplatform_3.speed_scale = 0.0
		"slow":
			timeplatform_3.speed_scale = 0.25
			
func _on_platform_3_timer_timeout() -> void:
	timeplatform_3.speed_scale = 1.0
	platform3btn.disabled = false
	set_process(false)

func _on_platform_4_btn_pressed() -> void:
	print("clicked platform 4 button")
	platform4btn.disabled = true
	set_process(true)
	platform_4_timer.wait_time = random.randf_range(1.0, 5.0)
	platform_4_timer.start()
	match activeSkill:
		"stop":
			timeplatform_4.speed_scale = 0.0
		"slow":
			timeplatform_4.speed_scale = 0.25

func _on_platform_4_timer_timeout() -> void:
	timeplatform_4.speed_scale = 1.0
	platform4btn.disabled = false
	set_process(false)
