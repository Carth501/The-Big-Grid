class_name Development extends Node

signal update_availability(availability : bool)
signal complete

var id : String
var changes : Dictionary
var available := true
var completed := false
var supplies : Dictionary
var action_unlocks : Array

func setup(new_id : String, supply_collection : Supply_Collection):
	id = new_id
	changes = DevelopmentsSingle.data[id].cost
	if(DevelopmentsSingle.data[id].has("actions")):
		action_unlocks = DevelopmentsSingle.data[id].actions
	for supply_id in changes:
		var supply = supply_collection.get_or_create_supply(supply_id)
		supplies[supply_id] = supply
		supply.update_value.connect(process_availability)
	process_availability()

func process_availability(_value = 1):
	var new_availability = test_supplies()
	if(new_availability != available):
		available = new_availability
		update_availability.emit(available)

func test_supplies():
	for supply_id in changes:
		var change = changes[supply_id]
		var supply = supplies[supply_id]
		var test = supply.test_deltas(change.deltas)
		if(!test):
			return false
	return true

func set_complete():
	complete.emit()
	completed = true
	
