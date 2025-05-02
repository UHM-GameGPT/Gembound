extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("die"):
			body.die()
	if GemManager.collected_gems.has("gem_float_clone-2"):
		var index = GemManager.collected_gems.find("gem_float_clone-2")
		GemManager.collected_gems.remove_at(index)
