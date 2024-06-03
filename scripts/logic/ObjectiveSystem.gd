class_name Objective_System extends Node

@export var supply_collection : Supply_Collection
var active_objective : Dictionary
var future_objectives := []
@export var game_controller : Game_Controller

func _ready():
	if(!game_controller.is_node_ready()):
		await game_controller.ready
	future_objectives = Objectives_Table_Single.data["test"]
	next()

func next():
	var new_objective = future_objectives.pop_front()
	if(new_objective == null):
		print("VICTORY")
		return
	active_objective = new_objective
	for supply_id in active_objective:
		var supply = supply_collection.get_supply(supply_id)
		while(supply == null):
			await supply_collection.new_supply
			supply = supply_collection.get_supply(supply_id)
		supply.set_objective(active_objective[supply_id])
