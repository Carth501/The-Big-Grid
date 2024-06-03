class_name Game_Controller extends Node

signal game_setup_ready

@export var supply_collection : Supply_Collection
@export var action_manager : Action_Manager
@export var starting_action_ids : Array[String]
@export var machine_factory : Machine_Factory
@export var save_file_panel : Button
@export var save_file_name : LineEdit
var save_name : String

func _ready():
	if(!supply_collection.is_node_ready()):
		await supply_collection.ready
	for id in starting_action_ids:
		action_manager.create_action(id)
	load_save()

func save_as():
	save(save_name)
	toggle_save_file_panel()

func save(save_name : String):
	var archive = { "file_name": save_name,
		"save_time": Time.get_datetime_string_from_system(true),
		"supplies": {},
	}
	for id in supply_collection.supplies:
		archive["supplies"][id] = write_supply_archive(id)
	var machine_data = {}
	for action_id in machine_factory.machine_registry:
		var machine_list = machine_factory.machine_registry[action_id]
		machine_data[action_id] = []
		for machine in machine_list:
			machine_data[action_id].append(get_machine_data(machine))
	archive["machines"] = machine_data
	Save_Handler_Single.write_save(archive)

func write_supply_archive(id : String):
	var supply = supply_collection.supplies[id]
	return {
		"value": supply.value,
		"v_max": supply.v_max,
		"max_upgrade_count": supply.max_upgrade_count,
		"active": supply.active
	}

func get_machine_data(machine : Machine) -> Dictionary:
	var conditional_data = []
	for conditional in machine.conditionals:
		conditional_data.append({
			"configuration": conditional.configuration,
			"comparator": conditional.comparator
			})
	return {
		"remaining_time": machine.timer.time_left,
		"conditionals": conditional_data
	}

func get_conditional_data(conditional: Conditional_Expression):
	return {"configuration": conditional.configuration,
	"comparator": conditional.comparator}

func _input(event):
	if event.is_action_pressed("save"):
		if(save_name == null || save_name == ""):
			toggle_save_file_panel()
		else:
			save(save_name)
	elif event.is_action_pressed("save as"):
		toggle_save_file_panel()

func change_save_name(new_name : String):
	save_name = new_name

func toggle_save_file_panel():
	save_file_panel.visible = !save_file_panel.visible

func load_save():
	var active_save = Save_Handler_Single.active_save
	if(active_save.has("file_name")):
		save_name = active_save["file_name"]
		save_file_name.text = save_name
	if(active_save.has("supplies")):
		for id in active_save["supplies"]:
			var saved_supply = active_save["supplies"][id]
			var supply = supply_collection.get_supply(id)
			supply.load_values(saved_supply)
	if(active_save.has("machines")):
		var action_id_buckets = active_save["machines"]
		for action_id in action_id_buckets:
			var action = action_manager.full_action_list[action_id]
			for machine_config in action_id_buckets[action_id]:
				var new_machine = machine_factory.build_machine(action)
				if(machine_config.has("remaining_time")):
					new_machine.load_timer(machine_config["remaining_time"])
				if(machine_config.has("conditionals")):
					new_machine.load_conditions(machine_config["conditionals"])

func autosave():
	save(save_name)
