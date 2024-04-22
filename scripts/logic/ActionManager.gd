class_name Action_Manager extends Node

signal new_action(id : String)

@export var supply_collection : Supply_Collection

func create_action(id : String):
	new_action.emit(id)

func apply_action(id : String):
	supply_collection.apply_changes(id)
