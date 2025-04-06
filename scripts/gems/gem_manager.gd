extends Node

# This will keep track of collected gems by their names or IDs
var collected_gems := []

# Call this function when a gem is collected
func collect_gem(gem_name: String) -> void:
	if gem_name not in collected_gems:
		collected_gems.append(gem_name)
