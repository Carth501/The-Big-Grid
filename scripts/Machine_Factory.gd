class_name Machine_Factory extends Node

@export var resources : resource_pile
var machine_registry : Dictionary

func build_machine(action_id : String) -> Machine:
	var new_machine = Machine.new()
	new_machine.set_id(action_id)
	if(!ActionsSingle.data.has(action_id)):
		push_error("invalid action_id while building a new machine")
	new_machine.set_changes(ActionsSingle.data[action_id].changes)
	new_machine.set_resource_pile(resources)
	add_child(new_machine)
	if(!machine_registry.has(action_id)):
		machine_registry[action_id] = []
	machine_registry[action_id].append(new_machine)
	print("machine built!")
	return new_machine
