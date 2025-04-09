extends Area2D

@onready var gem: AnimatedSprite2D = $Gem
@onready var gem_collected: AudioStreamPlayer = $Collected
@onready var stopbtn: TextureButton = $"../stop"
@onready var slowbtn: TextureButton = $"../slow"

@export var gem_name: String = "gem_stoptime"

func _ready() -> void:
	if GemManager.collected_gems.has(gem_name):
		queue_free()
	else:
		gem.play("idle")
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Collect gem and notify GemManager
		GemManager.collect_gem(gem_name)
		gem.visible = false
		gem_collected.play()
		stopbtn.visible = true
		#slowbtn.visible = true
		await gem_collected.finished
		PlayerState.dash_unlocked = true
		body.can_dash = true
		queue_free()
