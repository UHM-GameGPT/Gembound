extends Area2D

@onready var gem: AnimatedSprite2D = $Gem
@onready var gem_collected: AudioStreamPlayer = $Collected

@export var gem_name: String = "gem_float_clone"
@export var float_ability: Ability

func _ready() -> void:
	if GemManager.collected_gems.has(gem_name):
		queue_free()
	else:
		gem.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Collect gem and notify GemManager
		GemManager.collect_gem(gem_name)
		gem.visible = false
		gem_collected.play()
		await gem_collected.finished
		PlayerState.float_unlocked = true
		body.current_ability = float_ability
		queue_free()
