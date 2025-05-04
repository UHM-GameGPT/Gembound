extends Node2D

@export var coconut_scene: PackedScene

func _ready():
	spawn_loop()

func spawn_loop() -> void:
	while true:
		var coconut = spawn_coconut()
		await coconut.tree_exited

func spawn_coconut() -> Node2D:
	if coconut_scene:
		var coconut = coconut_scene.instantiate()
		get_parent().add_child.call_deferred(coconut)
		coconut.global_position = global_position
		return coconut
	return null
