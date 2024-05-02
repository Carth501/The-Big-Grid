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
	timer.wait_time = interval
