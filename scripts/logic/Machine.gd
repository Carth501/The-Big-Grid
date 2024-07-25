class_name Machine extends Node

signal new_conditional(Conditional_Value)
signal update_name(String)
signal update_active(bool)
signal update_interval(float)

var action : Action
var timer : Timer
var conditionals := []

func set_action(new_action : Action):
	action = new_action

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(check_conditions)
	timer.wait_time = 1
	timer.start()

func check_conditions():
	for condition in conditionals:
		if(condition != null && !condition.evaluation):
			return
	apply_changes()

func apply_changes():
	action.apply()

func set_interval(interval : float):
	if(interval > 10):
		push_warning("interval too long")
	elif(interval < 1):
		push_warning("interval too short")
	else:
		timer.wait_time = interval
		update_interval.emit(interval)

func get_interval() -> float:
	return timer.wait_time

func set_machine_name(value : String):
	name = value
	update_name.emit(value)

func set_running(setting : bool):
	if(setting):
		timer.set_paused(false)
	else:
		timer.set_paused(true)
	update_active.emit(!timer.paused)

func get_running() -> float:
	return !timer.is_stopped() && !timer.paused

func add_conditional():
	var conditional_instance = Conditional_Expression.new()
	add_child(conditional_instance)
	conditionals.append(conditional_instance)
	new_conditional.emit(conditional_instance)
	conditional_instance.delete_this.connect(remove_conditional)

func remove_conditional(conditional : Conditional_Expression):
	var index = conditionals.find(conditional)
	if(index >= 0):
		conditionals.remove_at(index)

func load_timer(remaining_time : float):
	timer.stop()
	var one_shot_timer = Timer.new()
	add_child(one_shot_timer)
	one_shot_timer.one_shot = true
	one_shot_timer.timeout.connect(check_conditions)
	one_shot_timer.timeout.connect(timer.start)
	one_shot_timer.wait_time = remaining_time
	one_shot_timer.start()

func load_conditions(config_array : Array):
	for config in config_array:
		var conditional_instance = Conditional_Expression.new()
		add_child(conditional_instance)
		conditional_instance.load_config(config["configuration"])
		conditional_instance.set_comparator(config["comparator"])
		conditionals.append(conditional_instance)
		new_conditional.emit(conditional_instance)
		conditional_instance.delete_this.connect(remove_conditional)
