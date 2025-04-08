extends TextureRect

@onready var animated_sprite: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("jumping")
	timer.start()

func _process(delta: float) -> void:
	pass
	#animated_sprite.play("jumping")

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	pass # Replace with function body.
