class_name Machine extends Node

var action : Action
var timer : Timer

func set_action(new_action : Action):
	action = new_action

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(apply_changes)
	timer.wait_time = 1
	timer.start()

func apply_changes():
	action.apply()

func set_interval(interval : float):
	if(interval > 10):
		push_warning("interval too long")
	elif(interval < 1):
		push_warning("interval too short")
	else:
		timer.wait_time = interval

func get_interval() -> float:
	return timer.wait_time

func set_running(setting : bool):
	if(setting):
		timer.set_paused(false)
	else:
		timer.set_paused(true)

func get_running() -> float:
	return timer.is_stopped()
