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
	
	#if PlayerState.stop_unlocked:
	if GemManager.collected_gems.has("gem_time1"):
		timestopempty.visible = false
		timestop.visible = true
		
	#if PlayerState.slow_unlocked:
	if GemManager.collected_gems.has("gem_time_slow"):
		timeslowempty.visible = false
		timeslow.visible = true
		
	#if PlayerState.clone_unlocked:
	if GemManager.collected_gems.has("gem_space_clone"):
		spacecloneempty.visible = false
		spaceclone.visible = true
		
	#if PlayerState.float_unlocked:
	if GemManager.collected_gems.has("gem_float_clone"):
		spacefloatempty.visible = false
		spacefloat.visible = true
		
	# print(GemManager.collected_gems)
