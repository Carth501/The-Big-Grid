class_name Sequencer extends Node

var pattern = []
var timer : Timer
var conditionals := []
var tier := 1
var current_index := 0

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(check_conditions)
	timer.wait_time = 10
	timer.start()

func check_conditions():
	for condition in conditionals:
		if(condition != null && !condition.evaluation):
			return
	if(pattern.size() > 0):
		proceed()

func proceed():
	var count := 0
	while(count < tier):
		var action = get_next_action()
		if(action.available):
			action.apply()
			count += 1
			current_index = (current_index + 1) % pattern.size()
		else:
			return

func get_next_action():
	var next_action = pattern[current_index]
	while(next_action == null):
		current_index = (current_index + 1) % pattern.size()
		next_action = pattern[current_index]
	return next_action

func move_index(original : int, new : int):
	var action_to_be_moved = pattern[original]
	pattern.remove_at(original)
	pattern.insert(new, action_to_be_moved)
