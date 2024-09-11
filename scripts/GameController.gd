class_name Game_Controller extends Node

signal game_setup_ready

@export var supply_collection : Supply_Collection
@export var action_manager : Action_Manager
@export var starting_action_ids : Array[String]
@export var machine_factory : Machine_Factory
@export var development_handler : Development_Handler
@export var sequencer_manager : Sequencer_Manager
@export var save_file_panel : Button
@export var save_file_name : LineEdit
@export var development_display : Development_Display
var save_name : String

func _ready():
	if(!supply_collection.is_node_ready()):
		await supply_collection.ready
	for id in starting_action_ids:
		action_manager.create_action(id)
	load_save()

func save_as():
	var success = save(save_name)
	if(success):
		toggle_save_file_panel()

func save(new_save_name : String) -> bool:
	if(new_save_name == null || new_save_name == ""):
		return false
	var archive = { "file_name": new_save_name,
		"save_time": Time.get_datetime_string_from_system(true),
		"supplies": {},
		"actions": {},
	}
	for id in supply_collection.supplies:
		archive["supplies"][id] = write_supply_archive(id)
	for action_id in action_manager.full_action_list:
		var action = action_manager.full_action_list[action_id]
		archive["actions"][action_id] = {"tags" : action.tags}
	var machine_data = {}
	for action_id in machine_factory.machine_registry:
		var machine_list = machine_factory.machine_registry[action_id]
		machine_data[action_id] = []
		for machine in machine_list:
			machine_data[action_id].append(get_machine_data(machine))
	archive["machines"] = machine_data
	archive["developments"] = development_handler.compeleted_developments
	var sequencer_data = {}
	for sequencer_id in sequencer_manager.sequencer_list:
		var sequencer = sequencer_manager.sequencer_list[sequencer_id]
		sequencer_data[sequencer_id] = get_sequencer_data(sequencer)
	archive["sequencers"] = sequencer_data
	archive["development_display"] = development_display.get_hidden_list()
	Save_Handler_Single.write_save(archive)
	Save_Handler_Single.index_saves()
	return true

func write_supply_archive(id : String):
	var supply = supply_collection.supplies[id]
	return {
		"value": supply.value,
		"v_max": supply.v_max,
		"max_upgrade_count": supply.max_upgrade_count,
		"active": supply.active,
		"tags": supply.tags
	}

func get_machine_data(machine : Machine) -> Dictionary:
	var conditional_data = []
	for conditional in machine.conditionals:
		conditional_data.append({
			"configuration": conditional.configuration,
			"comparator": conditional.comparator
			})
	return {
		"name": machine.name,
		"remaining_time": machine.timer.time_left,
		"active": machine.get_running(),
		"interval": machine.get_interval(),
		"conditionals": conditional_data,
		"tier": machine.tier
	}

func get_conditional_data(conditional: Conditional_Expression):
	return {"configuration": conditional.configuration,
	"comparator": conditional.comparator}

func get_sequencer_data(sequencer : Sequencer) -> Dictionary:
	var pattern = []
	for action in sequencer.pattern:
		if(action == null):
			pattern.append(null)
		else:
			pattern.append(action.id)
	return {
		"name": sequencer.name,
		"remaining_time": sequencer.timer.time_left,
		"active": sequencer.get_running(),
		"interval": sequencer.timer.wait_time,
		"tier": sequencer.tier,
		"pattern": pattern,
		"branch_access": sequencer.branch_access
	}

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
			var supply = supply_collection.get_or_create_supply(id)
			supply.load_values(saved_supply)
	if(active_save.has("actions")):
		for id in active_save["actions"]:
			var saved_action = active_save["actions"][id]
			if(!action_manager.full_action_list.has(id)):
				action_manager.create_action(id)
			var action = action_manager.full_action_list[id]
			action.set_tags(saved_action["tags"])
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
				if(machine_config.has("name")):
					new_machine.set_machine_name(machine_config["name"])
				if(machine_config.has("active")):
					new_machine.set_running(machine_config["active"])
				if(machine_config.has("interval")):
					new_machine.set_interval(machine_config["interval"])
				if(machine_config.has("tier")):
					new_machine.set_tier(machine_config["tier"])
				else:
					new_machine.set_tier(1)
	if(active_save.has("developments")):
		var devs = active_save.developments
		development_handler.set_completed_developments(devs)
	if(active_save.has("sequencers")):
		sequencer_manager.load_sequencers(active_save.sequencers)
	if(active_save.has("development_display")):
		development_display.load_hidden_list(active_save.development_display)

func autosave():
	save("autoSave")

func SaveButton():
	toggle_save_file_panel()

func _on_auto_save_timer_timeout() -> void:
	autosave()

func _on_help_pressed() -> void:
	$TutorialPopUp.show()
