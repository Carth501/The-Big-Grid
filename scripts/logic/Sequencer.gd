class_name Sequencer extends Node

signal name_changed(new_name)
signal tier_changed(new_teir)
signal update_active(setting)
signal add_action(index, action)
signal remove_action(index)
signal add_action_slot
signal request_action(sequencer)
signal purchase_branch_access_hover(cost)
signal end_purchase_hover()
signal open_branch_access_prompt(sequencer)

var pattern = []
var timer : Timer
var conditionals := []
var tier := 1
var current_index := 0
var request_index := 0
var branch_access := []
var action_decision : Action
var supply_collection : Supply_Collection
var action_slot_cost = {
			"processing_subunit": {
				"deltas": [
					-2
				]
			}
		}

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(check_conditions)
	timer.wait_time = 1
	timer.start()

func setup(new_supply_collection : Supply_Collection):
	supply_collection = new_supply_collection

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
		if(action == null):
			return
		if(action.available):
			action.apply()
			count += 1
			current_index = (current_index + 1) % pattern.size()
		else:
			return

func get_next_action():
	var start = current_index
	var next_action = pattern[current_index]
	while(next_action == null):
		current_index = (current_index + 1) % pattern.size()
		next_action = pattern[current_index]
		if(current_index == start):
			return null
	return next_action

func move_index(original : int, new : int):
	var action_to_be_moved = pattern[original]
	pattern.remove_at(original)
	pattern.insert(new, action_to_be_moved)

func change_tier(new_tier : int):
	tier = new_tier
	tier_changed.emit(tier)

func set_running(setting : bool):
	if(setting):
		timer.set_paused(false)
	else:
		timer.set_paused(true)
	update_active.emit(!timer.paused)

func get_running() -> float:
	return !timer.is_stopped() && !timer.paused

func begin_slot_fill(index : int):
	request_index = index
	request_action.emit(self)

func fufill_request(action: Action):
	var access = check_branch_access(action.branches)
	if(access):
		pattern[request_index] = action
		add_action.emit(request_index, action)
		end_purchase_hover.emit()
	else:
		action_decision = action
		open_branch_access_prompt.emit(self)
		end_purchase_hover.emit()

func clear_slot(index : int):
	pattern[index] = null
	remove_action.emit(index)

func set_interval(value : float):
	timer.wait_time = clampf(value, 1, 10)

func set_last_slot(action : Action):
	if(pattern.size() > 0):
		pattern[pattern.size() - 1] = action

func set_selection_hover(action : Action):
	if(action.branches.size() == 0):
		return
	var access = check_branch_access(action.branches)
	if(!access):
		var branch_id = action.branches[0]
		var branch_access_cost = BranchesSingle.data[branch_id]
		purchase_branch_access_hover.emit(branch_access_cost)

func end_selection_hover():
	end_purchase_hover.emit()

func check_branch_access(branches: Array):
	for branch in branches:
		if(branch_access.has(branch)):
			return true
	return false

func purchase_branch_access():
	if(action_decision.branches.size() > 0):
		var branch = action_decision.branches[0]
		var branch_cost = BranchesSingle.data[branch].access_cost
		var success = supply_collection.attempt_purchase(branch_cost)
		if(success):
			branch_access.append(branch)
			fufill_request(action_decision)

func add_slot():
	pattern.push_back(null)

func purchase_action_slot():
	var success = supply_collection.attempt_purchase(action_slot_cost)
	if(success):
		pattern.push_back(null)
		add_action_slot.emit()
