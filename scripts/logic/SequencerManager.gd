class_name Sequencer_Manager extends Node

signal new_sequencer(id : int)
signal request_action()
signal cancel_action_request()
var sequencer_list := {}
var requesting_sequencer : Sequencer

func create_sequencer():
	var id = sequencer_list.keys().size()
	var sequencer = Sequencer.new()
	add_child(sequencer)
	sequencer_list[id] = sequencer
	new_sequencer.emit(id)
	sequencer.request_action.connect(begin_action_request)

func begin_action_request(sequencer : Sequencer):
	requesting_sequencer = sequencer
	request_action.emit()

func fufill_request(action : Action):
	requesting_sequencer.fufill_request(action)

func end_action_request():
	cancel_action_request.emit()
