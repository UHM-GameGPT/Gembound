extends Node2D

class_name GemCounter

# acquired gems
@onready var timestop: AnimatedSprite2D = $timestop
@onready var timeslow: AnimatedSprite2D = $timeslow
@onready var spaceclone: AnimatedSprite2D = $spaceclone
@onready var spacefloat: AnimatedSprite2D = $spacefloat

# blank gems
@onready var timestopempty: AnimatedSprite2D = $timestopempty
@onready var timeslowempty: AnimatedSprite2D = $timeslowempty
@onready var spacecloneempty: AnimatedSprite2D = $spacecloneempty
@onready var spacefloatempty: AnimatedSprite2D = $spacefloatempty

func countgems():
	
	if PlayerState.stop_unlocked:
		timestopempty.visible = false
		timestop.visible = true
		
	if PlayerState.slow_unlocked:
		timeslowempty.visible = false
		timeslow.visible = true
		
	if PlayerState.clone_unlocked:
		spacecloneempty.visible = false
		spaceclone.visible = true
		
	if PlayerState.float_unlocked:
		spacefloatempty.visible = false
		spacefloat.visible = true
		
	# print(GemManager.collected_gems)
