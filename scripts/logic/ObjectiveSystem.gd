class_name Objective_System extends Node

signal newStepDescription(String)
@export var supply_collection : Supply_Collection
var active_objective : Dictionary
var future_objectives := []
@export var game_controller : Game_Controller

func _ready():
	if(!game_controller.is_node_ready()):
		await game_controller.ready
	future_objectives = Objectives_Table_Single.data["test"].duplicate()
	next()

func next():
	unsubscribe_supplies()
	var new_objective = future_objectives.pop_front()
	if(new_objective == null):
		print("VICTORY")
		return
	active_objective = new_objective
	for supply_id in active_objective:
		if(supply_id == "stepId"):
			var stepId = active_objective[supply_id]
			newStepDescription.emit(ObjectivesTextsSingle.data[stepId])
		else:
			var supply = supply_collection.get_or_create_supply(supply_id)
			while(supply == null):
				await supply_collection.new_supply
				supply = supply_collection.get_supply(supply_id)
			supply.set_objective(active_objective[supply_id])
			supply.update_value.connect(check_victory)
			check_victory(0)
			supply.reveal()

func check_victory(_value):
	if(check_conditions()):
		next()

func check_conditions():
	for supply_id in active_objective:
		if(supply_id != "stepId"):
			var supply = supply_collection.get_supply(supply_id)
			var criteria_list = active_objective[supply_id]
			for criteria in criteria_list:
				if(criteria.has("less_than")):
					return check_less_than(supply, criteria.less_than)
				elif(criteria.has("equal_to")):
					return check_equal_to(supply, criteria.equal_to)
				elif(criteria.has("greater_than")):
					return check_greater_than(supply, criteria.greater_than)

func unsubscribe_supplies():
	for supply_id in active_objective:
		if(supply_id != "stepId"):
			var supply = supply_collection.get_supply(supply_id)
			supply.update_value.disconnect(check_victory)
			supply.unset_objective()

func check_less_than(supply : Supply, criteria : Dictionary) -> bool:
	if(criteria.has("supply")):
		var id = criteria["supply"]
		var other = supply_collection.get_supply(id)
		return supply.value < other.value
	else:
		var value = criteria["const"]
		return supply.value < value

func check_equal_to(supply : Supply, criteria : Dictionary) -> bool:
	if(criteria.has("supply")):
		var id = criteria["supply"]
		var other = supply_collection.get_supply(id)
		return supply.value == other.value
	else:
		var value = criteria["const"]
		return supply.value == value

func check_greater_than(supply : Supply, criteria : Dictionary) -> bool:
	if(criteria.has("supply")):
		var id = criteria["supply"]
		var other = supply_collection.get_supply(id)
		return supply.value > other.value
	else:
		var value = criteria["const"]
		return supply.value > value
