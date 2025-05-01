extends TextureRect

@onready var gem_counter: GemCounter = $GemCounter

func _ready():
	if not Global.has_faded_from_white_in_phase2:
		$WhiteFade.modulate = Color(1, 1, 1, 1)
		var tween = create_tween()
		tween.tween_property($WhiteFade, "modulate:a", 0.0, 1.0)
		Global.has_faded_from_white_in_phase2 = true
	else:
		$WhiteFade.modulate = Color(1, 1, 1, 0)  # Skip fade; start clear
		
	gem_counter.countgems()
