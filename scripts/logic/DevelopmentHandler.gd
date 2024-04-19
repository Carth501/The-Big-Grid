class_name Development_Handler extends Node

signal complete_development(id : String)

@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
var previous_developments : Array = []

func attempt_development(id : String):
	var candidate = DevelopmentsSingle.data[id]
	var success = supply_collection.attempt_purchase(candidate.cost)
	if(success):
		complete_development.emit(id)
		previous_developments.append(id)
		if(candidate.has("actions")):
			for action_id in candidate.actions:
				action_manager.build_action_button(action_id)
