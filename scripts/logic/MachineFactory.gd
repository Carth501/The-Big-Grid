class_name Machine_Factory extends Node

@export var supply_collection : Supply_Collection
var machine_registry : Dictionary

func build_machine(action_id : String) -> Machine:
	var new_machine = Machine.new()
	if(!ActionsSingle.data.has(action_id)):
		push_error("invalid action_id while building a new machine")
	new_machine.set_id(action_id)
	new_machine.set_supply(supply_collection)
	add_child(new_machine)
	if(!machine_registry.has(action_id)):
		machine_registry[action_id] = []
	machine_registry[action_id].append(new_machine)
	return new_machine
