class_name Sequencer extends Node

signal name_changed(new_name)
signal tier_changed(new_teir)
signal update_active(setting)

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

func set_sequencer_name(new_name : String):
	name = new_name
	name_changed.emit(name)

func get_sequencer_name():
	return name

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

func change_teir(new_teir : int):
	tier = new_teir
	tier_changed.emit(tier)

func set_running(setting : bool):
	if(setting):
		timer.set_paused(false)
	else:
		timer.set_paused(true)
	update_active.emit(!timer.paused)

func get_running() -> float:
	return !timer.is_stopped() && !timer.paused
