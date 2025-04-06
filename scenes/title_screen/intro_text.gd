extends Node
# Code from TheBuffED https://www.youtube.com/watch?v=Cp9g2GY7aTg

var messages = [
	"The balance is broken.", 
	"Space bends... Time warps...",
	"The gems are lost.",
	"Find them. Before all is undone."
]

var typing_speed = .1
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0

func _ready():
	start_dialogue()
	
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func stop_dialogue():
	# get_parent().remove_child(self)
	queue_free()

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$Label.text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$next_message.start()

func _on_next_message_timeout():
	if (current_message == len(messages) - 1):
		load_next_scene()
	else: 
		current_message += 1
		display = ""
		current_char = 0
		$next_char.start()
		
func load_next_scene():
	var transition_screen = get_node("/root/TransitionScreen")
	transition_screen.on_transition_finished.connect(_on_fade_complete)
	transition_screen.transition()
	
func _on_fade_complete():
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial_1.tscn")
