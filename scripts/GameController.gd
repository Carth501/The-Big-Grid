extends Node

@export var supply_collection : Supply_Collection
@export var action_manager : Action_Manager
@export var starting_action_ids : Array[String]

func _ready():
	if(!supply_collection.is_node_ready()):
		await supply_collection.ready
	for id in starting_action_ids:
		action_manager.create_action(id)
