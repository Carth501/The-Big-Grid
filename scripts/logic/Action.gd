class_name Action extends Node

signal update_availability(availability : bool)
signal open_menu(id : String)
signal new_machine(machine : Machine)
signal update_action_name(new_name : String)
signal tag_added(String)
signal tag_removed(String)

var id : String
var changes : Dictionary
var available := true
var automation_available := true
var supplies : Dictionary
var automation_cost : Dictionary
var filter_foreman : Filter_Foreman
var supply_collection : Supply_Collection
var machine_factory : Machine_Factory
var string_data : Dictionary
var translated_action_name : String
var automation_hover := true
var automation_focus := false
var tags : Array[String] = []
var audio : String

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
	else:
		automation_available = false
	supply_collection = package["supply_collection"]
	machine_factory = package["machine_factory"]
	for supply_id in changes:
		var supply = supply_collection.get_or_create_supply(supply_id)
		supplies[supply_id] = supply
		supply.update_value.connect(process_availability)
		supply.activate()
	if(ActionsSingle.data[id].has("audio")):
		audio = ActionsSingle.data[id].audio
	process_availability()
	string_data = ActionTranslatorSingle.data[id]
	write_translation_text()
	SupplyTranslatorSingle.new_override.connect(decide_if_name_update_needed)

func apply():
	supply_collection.apply_changes(changes)

func apply_multiple(value : int):
	supply_collection.apply_changes_mult(changes, value)

func decide_if_name_update_needed(supply : String):
	if(string_data.has("supplies") && string_data.supplies.has(supply)):
		write_translation_text()
		update_action_name.emit(translated_action_name)

func get_translation_text() -> String:
	return translated_action_name

func write_translation_text():
	if(string_data.has("supplies")):
		var supply_ids : Array = string_data.supplies
		var supply_names = SupplyTranslatorSingle.get_supply_names(supply_ids)
		var translated_name = string_data.name % supply_names
		translated_action_name = translated_name
	else:
		translated_action_name = string_data.name

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
		cost = calculate_machine_cost()
		if(automation_hover):
			filter_foreman.set_primary_filter(cost)
		if(automation_focus):
			filter_foreman.set_secondary_filter(cost)

func open():
	open_menu.emit(id)

func set_filter():
	filter_foreman.set_primary_filter(changes)

func unset_filter():
	filter_foreman.clear_primary_filter()
	automation_hover = false

func gain_focus():
	filter_foreman.set_secondary_filter(changes)

func lose_focus():
	filter_foreman.clear_secondary_filter()
	automation_focus = false

func set_machine_purchase_filter():
	filter_foreman.set_primary_filter(calculate_machine_cost())
	automation_hover = true

func gain_machine_purchase_focus():
	filter_foreman.set_secondary_filter(calculate_machine_cost())
	automation_focus = true

func calculate_machine_cost() -> Dictionary:
	if(automation_cost == null || automation_cost == {}):
		return {}
	#var count := machine_factory.get_machine_count_by_id(id) + 1
	var cost = automation_cost.duplicate(true)
	#for supply in cost:
		#var supply_deltas = cost[supply].deltas
		#for index in range(supply_deltas.size()):
			#supply_deltas[index] *= count
	return cost

func add_tag(tag : String):
	if(!tags.has(tag)):
		tags.append(tag)
		tag_added.emit(tag)

func remove_tag(tag : String):
	if(tags.has(tag)):
		tags.erase(tag)
		tag_removed.emit(tag)

func set_tags(new_tags : Array):
	for tag in new_tags:
		add_tag(tag)
