extends Area2D

@onready var gem: AnimatedSprite2D = $Gem
@onready var gem_collected: AudioStreamPlayer = $Collected
@onready var gem_counter: GemCounter = $"../../GemCounter"

@export var gem_name: String = "gem_time_slow"

func _ready() -> void:
	if GemManager.collected_gems.has(gem_name):
		queue_free()
	else:
		gem.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GemManager.collect_gem(gem_name)
		gem.visible = false
		gem_collected.play()
		await gem_collected.finished

		var player = body as Player
		if player:
			PlayerState.slow_unlocked = true  # Grant the ability
		queue_free()
		gem_counter.countgems()
