extends Node2D

class_name GemCounter

@onready var timestop: AnimatedSprite2D = $timestop
@onready var timeslow: AnimatedSprite2D = $timeslow
@onready var spaceclone: AnimatedSprite2D = $spaceclone
@onready var spacefloat: AnimatedSprite2D = $spacefloat

func countgems():
	
	if PlayerState.stop_unlocked:
		timestop.visible = true
		
	if PlayerState.slow_unlocked:
		timeslow.visible = true
		
