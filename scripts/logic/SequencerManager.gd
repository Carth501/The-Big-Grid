class_name Sequencer_Manager extends Node

signal new_sequencer(id : int)
signal request_action()
signal cancel_action_request()
var sequencer_list := {}
var requesting_sequencer : Sequencer
@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
@export var filter_foreman : Filter_Foreman
var sequencer_cost = {
			"modular_computer": {
				"deltas": [
					-2
				]
			}
		}
var mass_paused := []

func attempt_sequencer_purchase():
	var success = attempt_purchase()
	if(success):
		create_sequencer()

func attempt_purchase() -> bool:
	return supply_collection.attempt_purchase(sequencer_cost)

func create_sequencer():
	var id = sequencer_list.keys().size()
	var sequencer = Sequencer.new()
	sequencer.setup(supply_collection)
	add_child(sequencer)
	sequencer_list[id] = sequencer
	new_sequencer.emit(id)
	sequencer.request_action.connect(begin_action_request)

func load_sequencers(new_sequencers : Dictionary):
	for id in new_sequencers:
		var sequencer = Sequencer.new()
		sequencer.setup(supply_collection)
		add_child(sequencer)
		sequencer_list[id] = sequencer
		var pattern = new_sequencers[id].pattern
		for action_id in pattern:
			sequencer.add_slot()
			if(action_id != null):
				var action = action_manager.full_action_list[action_id]
				sequencer.set_last_slot(action)
		sequencer.set_running(new_sequencers[id].active)
		sequencer.change_tier(new_sequencers[id].tier)
		sequencer.set_interval(new_sequencers[id].interval)
		if(new_sequencers[id].has("branch_access")):
			sequencer.branch_access = new_sequencers[id].branch_access
		new_sequencer.emit(id)
		sequencer.request_action.connect(begin_action_request)

func begin_action_request(sequencer : Sequencer):
	requesting_sequencer = sequencer
	request_action.emit()

func fufill_request(action : Action):
	requesting_sequencer.fufill_request(action)

func end_action_request():
	cancel_action_request.emit()

func set_sequencer_cost_filter():
	filter_foreman.set_primary_filter(sequencer_cost)

func set_filter(cost : Dictionary):
	filter_foreman.set_primary_filter(cost)

func unset_filter():
	filter_foreman.clear_primary_filter()

func set_selection_hover(action : Action):
	requesting_sequencer.set_selection_hover(action)

func end_selection_hover():
	requesting_sequencer.end_selection_hover()

func mass_pause():
	for sequencer_id in sequencer_list:
		var sequencer : Sequencer = sequencer_list[sequencer_id]
		if(sequencer.get_running()):
			mass_paused.append(sequencer)
			sequencer.set_running(false)

func mass_resume():
	for sequencer in mass_paused:
		sequencer.set_running(true)
	mass_paused.clear()
