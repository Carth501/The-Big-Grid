class_name Development_Handler extends Node

signal complete_development(id : String)

@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
var previous_developments : Array = []
var full_development_list : Dictionary

func _ready():
	full_development_list = DevelopmentsSingle.data

func get_development_options() -> Array[String]:
	var dev_options_list : Array[String] = []
	for dev in full_development_list:
		if(!previous_developments.has(dev)):
			dev_options_list.append(dev)
	return dev_options_list

func attempt_development(id : String):
	var candidate = DevelopmentsSingle.data[id]
	var success = supply_collection.attempt_purchase(candidate.cost)
	if(success):
		complete_development.emit(id)
		previous_developments.append(id)
		if(candidate.has("actions")):
			for action_id in candidate.actions:
				action_manager.create_action(action_id)
