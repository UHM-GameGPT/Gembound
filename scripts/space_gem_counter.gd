extends Node2D

class_name Space_GemCounter

# acquired gems
@onready var spaceclone: AnimatedSprite2D = $spaceclone
@onready var spacefloat: AnimatedSprite2D = $spacefloat


# blank gems
@onready var spacecloneempty: AnimatedSprite2D = $spacecloneempty
@onready var spacefloatempty: AnimatedSprite2D = $spacefloatempty

func countgems():
		
	#if PlayerState.clone_unlocked:
	if GemManager.collected_gems.has("gem_space_clone"):
		spacecloneempty.visible = false
		spaceclone.visible = true
		
	#if PlayerState.float_unlocked:
	if GemManager.collected_gems.has("gem_float_clone"):
		spacefloatempty.visible = false
		spacefloat.visible = true
		
	# print(GemManager.collected_gems)
