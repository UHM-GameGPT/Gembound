extends Node2D

class_name GemCounter

@onready var timestop: AnimatedSprite2D = $timestop
@onready var timeslow: AnimatedSprite2D = $timeslow
@onready var spaceclone: AnimatedSprite2D = $spaceclone
@onready var spacefloat: AnimatedSprite2D = $spacefloat
@onready var counterlabel: Label = $counterlabel

var gemcounter: int = 0

func countgems():
	if PlayerState.stop_unlocked:
		timestop.visible = true
		gemcounter += 1
	
	if PlayerState.slow_unlocked:
		timeslow.visible = true
		gemcounter += 1
	
	counterlabel.text = str(gemcounter) + "/4 gems collected"
