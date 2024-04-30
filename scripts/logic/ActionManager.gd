class_name Action_Manager extends Node

signal open_menu(action : Action)
signal new_action(id : String)

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
