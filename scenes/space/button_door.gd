extends StaticBody2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

func open():
	if anim_sprite.animation != "disappear":
		anim_sprite.play("disappear")
		collider.call_deferred("set_disabled", true)

func close():
	if anim_sprite.animation != "reappear":
		anim_sprite.play("reappear")
		collider.call_deferred("set_disabled", false)
