class_name Machine_Factory extends Node

signal new_machine_built(machine : Machine)
@export var supply_collection : Supply_Collection
@export var copy_handler : Copy_Handler
var machine_registry : Dictionary
var mass_paused := []

func build_machine(action : Action) -> Machine:
	var new_machine = Machine.new()
	new_machine.set_action(action)
	add_child(new_machine)
	if(!machine_registry.has(action.id)):
		machine_registry[action.id] = []
	machine_registry[action.id].append(new_machine)
	var new_name := str("machine #", machine_registry[action.id].size())
	new_machine.set_name(new_name)
	new_machine.set_running(true)
	new_machine.set_tier(1)
	new_machine_built.emit(new_machine)
	new_machine.copy_handler = copy_handler
	return new_machine

func get_machines_by_id(id : String) -> Array:
	if(machine_registry.has(id)):
		return machine_registry[id]
	return []

func get_machine_count_by_id(id : String) -> int:
	if(machine_registry.has(id)):
		return machine_registry[id].size()
	return 0

func mass_pause():
	for action_id in machine_registry:
		for machine in machine_registry[action_id]:
			if(machine.get_running()):
				mass_paused.append(machine)
				machine.set_running(false)

func mass_resume():
	for machine in mass_paused:
		machine.set_running(true)
	mass_paused.clear()
