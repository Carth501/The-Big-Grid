class_name Action extends Node

signal update_availability(availability : bool)
signal open_menu(id : String)
signal new_machine(machine : Machine)

var id : String
var changes : Dictionary
var available := true
var supplies : Dictionary
var automation_cost : Dictionary
var filter_foreman : Filter_Foreman
var supply_collection : Supply_Collection
var machine_factory : Machine_Factory

func setup(package : Dictionary):
	if(!package.has("id")):
		push_error("action setup without ID")
	if(!package.has("supply_collection")):
		push_error("action setup without supply_collection")
	if(!package.has("machine_factory")):
		push_error("action setup without machine_factory")
	id = package["id"]
	changes = ActionsSingle.data[id].changes
	if(ActionsSingle.data[id].has("automation_cost")):
		automation_cost = ActionsSingle.data[id].automation_cost
	supply_collection = package["supply_collection"]
	machine_factory = package["machine_factory"]
	for supply_id in changes:
		var supply = supply_collection.get_or_create_supply(supply_id)
		supplies[supply_id] = supply
		supply.update_value.connect(process_availability)
		supply.activate()
	process_availability()

func apply():
	supply_collection.apply_changes(changes)

func get_translation_text() -> String:
	return ActionTranslatorSingle.data[id]

func set_filter_foreman(new_filter_foreman : Filter_Foreman):
	filter_foreman = new_filter_foreman

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

func attempt_machine_purchase():
	if(automation_cost == null || automation_cost == {}):
		return
	var cost = calculate_machine_cost()
	var success = supply_collection.attempt_purchase(cost)
	if(success):
		var machine = machine_factory.build_machine(self)
		new_machine.emit(machine)

func open():
	open_menu.emit(id)

func set_filter():
	filter_foreman.set_primary_filter(changes)

func unset_filter():
	filter_foreman.clear_primary_filter()

func gain_focus():
	filter_foreman.set_secondary_filter(changes)

func lose_focus():
	filter_foreman.clear_secondary_filter()

func set_machine_purchase_filter():
	filter_foreman.set_primary_filter(calculate_machine_cost())

func gain_machine_purchase_focus():
	filter_foreman.set_secondary_filter(calculate_machine_cost())

func calculate_machine_cost() -> Dictionary:
	if(automation_cost == null || automation_cost == {}):
		return {}
	var count := machine_factory.get_machine_count_by_id(id) + 1
	var cost = automation_cost.duplicate(true)
	for supply in cost:
		var supply_deltas = cost[supply].deltas
		for index in range(supply_deltas.size()):
			supply_deltas[index] *= count
	return cost
	
