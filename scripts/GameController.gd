extends Node

@export var supply_collection : Supply_Collection
@export var action_manager : Action_Manager
@export var starting_action_ids : Array[String]
@export var machine_factory : Machine_Factory

func _ready():
	if(!supply_collection.is_node_ready()):
		await supply_collection.ready
	for id in starting_action_ids:
		action_manager.create_action(id)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save("autosave")

func save(save_name : String):
	var archive = { "file_name": save_name,
		"save_time": Time.get_datetime_string_from_system(true),
		"supplies": {},
		"actions": {},
	}
	for id in supply_collection.supplies:
		var supply = supply_collection.supplies[id]
		archive["supplies"][id] = {
			"value": supply.value,
			"v_max": supply.v_max,
			"max_upgrade_count": supply.max_upgrade_count,
			"active": supply.active
		}
	for action_id in action_manager.full_action_list:
		var action = action_manager.full_action_list[action_id]
		archive["actions"][action_id] = {
			"available": action.available,
		}
	var machine_data = []
	for action_id in machine_factory.machine_registry:
		var machine_list = machine_factory.machine_registry[action_id]
		for machine in machine_list:
			machine_data.append(get_machine_data(machine))
	archive["machines"] = machine_data
	Save_Handler_Single.write_save(archive)

func get_machine_data(machine : Machine) -> Dictionary:
	var conditional_data = []
	for conditional in machine.conditionals:
		conditional_data.append(conditional)
	return {
		"remaining_time": machine.timer.time_left,
		"conditionals": conditional_data
	}

func get_conditional_data(conditional: Conditional_Expression):
	return {"configuration": conditional.configuration,
	"comparator": conditional.comparator}
