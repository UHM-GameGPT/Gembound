extends CharacterBody2D

@onready var animated_sprite = $CloneSprite

const LIFE_TIME = 10.0
var life_timer := 0.0

func _ready():
	animated_sprite.play("idle")
	add_to_group("weights")

func _physics_process(delta: float) -> void:
	# clone doesn't move or just animates in place
	life_timer += delta
	if life_timer >= LIFE_TIME:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "FinalBoss_phase2" and body.has_method("stun"):
		body.stun()
		queue_free()  # Optional: destroy clone after stun
	if body.name == "mini_boss2" and body.has_method("stun"):
		body.stun()
		queue_free()  # Optional: destroy clone after stun
