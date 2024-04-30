class_name Machine_Factory extends Node

@export var supply_collection : Supply_Collection
var machine_registry : Dictionary

func build_machine(action : Action) -> Machine:
	var new_machine = Machine.new()
	new_machine.set_action(action)
	add_child(new_machine)
	if(!machine_registry.has(action.id)):
		machine_registry[action.id] = []
	machine_registry[action.id].append(new_machine)
	return new_machine

func get_machines_by_id(id : String) -> Array[Machine]:
	if(machine_registry.has(id)):
		return machine_registry[id]
	return []

func get_machine_count_by_id(id : String) -> int:
	if(machine_registry.has(id)):
		return machine_registry[id].size()
	return 0
