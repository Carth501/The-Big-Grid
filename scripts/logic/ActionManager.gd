class_name Action_Manager extends Node

signal new_action(id : String)

@export var supply_collection : Supply_Collection
var full_action_list : Dictionary = {}

func create_action(id : String):
	var new_action_logic = Action.new()
	add_child(new_action_logic)
	full_action_list[id] = new_action_logic
	new_action_logic.setup(id, supply_collection)
	new_action.emit(id)

func apply_action(id : String):
	supply_collection.apply_changes(id)

