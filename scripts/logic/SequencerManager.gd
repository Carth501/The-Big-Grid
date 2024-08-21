class_name Sequencer_Manager extends Node

signal new_sequencer(id : int)
var sequencer_list := {}

func create_sequencer():
	var id = sequencer_list.keys().size()
	var sequencer = Sequencer.new()
	add_child(sequencer)
	sequencer_list[id] = sequencer
	new_sequencer.emit(id)
