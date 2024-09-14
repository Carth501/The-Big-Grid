class_name Objective_System extends Node

signal newStepDescription(String)
signal overallGoalDescription(description : String)
@export var supply_collection : Supply_Collection
@export var machine_factory : Machine_Factory
var active_objective : Dictionary
var future_objectives := []
@export var music_system : MusicSystem

func _ready():
	future_objectives = Objectives_Table_Single.data["test"].duplicate()
	overallGoalDescription.emit(ObjectivesTextsSingle.data["test"])
	next()

func next():
	var new_objective = future_objectives.pop_front()
	if(new_objective == null):
		overallGoalDescription.emit(ObjectivesTextsSingle.data["test_finished"])
		newStepDescription.emit("Gather Supplies for the next update!")
		if(music_system != null):
			music_system.play_victory()
		return
	active_objective = new_objective
	var stepId = active_objective["stepId"]
	newStepDescription.emit(ObjectivesTextsSingle.data[stepId])
	if(active_objective.has("supplies")):
		for supply_id in active_objective["supplies"]:
			var supply = supply_collection.get_or_create_supply(supply_id)
			while(supply == null):
				await supply_collection.new_supply
				supply = supply_collection.get_supply(supply_id)
			supply.set_objective(active_objective["supplies"][supply_id])
			supply.update_value.connect(check_victory)
			check_victory(0)
			supply.reveal()
	if(active_objective.has("machines")):
		machine_factory.new_machine_built.connect(check_victory)

func check_victory(_value):
	if(check_conditions()):
		if(active_objective.has("supplies")):
			unsubscribe_supplies()
		if(active_objective.has("machines")):
			machine_factory.new_machine_built.disconnect(check_victory)
		next()

func check_conditions():
	if(active_objective.has("supplies")):
		var criteria_list = active_objective["supplies"]
		for supply_id in criteria_list:
			var supply = supply_collection.get_supply(supply_id)
			var criteria = criteria_list[supply_id]
			if(criteria.has("less_than") && !check_less_than(supply, criteria.less_than)):
				return false
			if(criteria.has("equal_to") && !check_equal_to(supply, criteria.equal_to)):
				return false
			if(criteria.has("greater_than") && !check_greater_than(supply, criteria.greater_than)):
				return false
	if(active_objective.has("machines")):
		for action_id in active_objective["machines"]:
			if(!machine_factory.machine_registry.has(action_id)):
				return false
			var action_criteria = active_objective["machines"][action_id]
			var objective_machines = machine_factory.machine_registry[action_id]
			var machine_count = objective_machines.size()
			if(action_criteria.has("less_than")):
				if(machine_count >= action_criteria["less_than"].const):
					return false
			if(action_criteria.has("equal_to")):
				if(machine_count != action_criteria["equal_to"].const):
					return false
			if(action_criteria.has("greater_than")):
				if(machine_count <= action_criteria["greater_than"].const):
					return false
	return true

func unsubscribe_supplies():
	for supply_id in active_objective["supplies"]:
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
