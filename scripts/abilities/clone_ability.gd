extends Ability
class_name CloneAbility

@export var clone_scene: PackedScene

func activate(user: Node2D):
	var clone = clone_scene.instantiate()
	clone.global_position = user.global_position + Vector2(20, 0)
	user.get_tree().current_scene.add_child(clone)
