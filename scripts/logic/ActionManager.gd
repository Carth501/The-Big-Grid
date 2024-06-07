class_name Action_Manager extends Node

signal open_menu(action : Action)
signal new_action(id : String)
signal action_search_filter(Array)

@export var supply_collection : Supply_Collection
@export var filter_foreman : Filter_Foreman
@export var machine_factory : Machine_Factory
var full_action_list : Dictionary = {}

func create_action(id : String):
	var new_action_logic = Action.new()
	add_child(new_action_logic)
	full_action_list[id] = new_action_logic
	var package = {
		"id": id, 
		"supply_collection": supply_collection,
		"machine_factory": machine_factory
	}
	new_action_logic.setup(package)
	new_action_logic.set_filter_foreman(filter_foreman)
	new_action.emit(id)
	new_action_logic.open_menu.connect(open_action_menu)

func open_action_menu(id : String):
	open_menu.emit(full_action_list[id])

func set_action_filter(new_search : String):
	if(new_search == null || new_search == ""):
		var action_ids : Array[String] = []
		for id in full_action_list:
			action_ids.append(id)
		action_search_filter.emit(action_ids)
		return
	var action_ids : Array[String] = []
	for id in full_action_list:
		var action_name = ActionTranslatorSingle.data[id]
		if(action_name.name.to_lower().contains(new_search.to_lower())):
			action_ids.append(id)
	action_search_filter.emit(action_ids)
