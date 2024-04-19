extends Node

@export var supply_collection : Supply_Collection
@export var action_manager : Action_Manager
@export var starting_supply_ids : Array[String]
@export var starting_action_ids : Array[String]

func _ready():
	for id in starting_supply_ids:
		supply_collection.add_supply(id)
	for id in starting_action_ids:
		action_manager.create_action(id)
