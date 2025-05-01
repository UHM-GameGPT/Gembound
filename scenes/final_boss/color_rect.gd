extends ColorRect

func _ready():
	# Start fully opaque
	$WhiteFade.modulate = Color(1, 1, 1, 1)

	# Create fade-out tween
	var tween = create_tween()
	tween.tween_property($WhiteFade, "modulate:a", 0.0, 1.5)  # Fade to transparent over 1.5 seconds
