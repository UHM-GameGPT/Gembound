extends Node2D

func show_message():
	$Label.visible = true  # Show the label (if initially hidden)
	$AnimationPlayer.play("show_tutorial")  # Play your animation (e.g., fade in or typewriter)
