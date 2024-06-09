class_name Development extends Node

signal update_availability(availability : bool)
signal complete
signal update_translations(translated_strings : Dictionary)

var id : String
var changes : Dictionary
var available := true
var completed := false
var supplies : Dictionary
var action_unlocks : Array
var filter_foreman : Filter_Foreman
var translation_data : Dictionary
var translated_strings : Dictionary

func setup(new_id : String, supply_collection : Supply_Collection):
	id = new_id
	changes = DevelopmentsSingle.data[id].changes
	if(DevelopmentsSingle.data[id].has("actions")):
		action_unlocks = DevelopmentsSingle.data[id].actions
	for supply_id in changes:
		var supply = supply_collection.get_or_create_supply(supply_id)
		supplies[supply_id] = supply
		supply.update_value.connect(process_availability)
	process_availability()
	SupplyTranslatorSingle.new_override.connect(decide_if_name_update_needed)
	translation_data = DevelopmentTranslatorSingle.data[id]
	write_translation_text()

func decide_if_name_update_needed(supply_id : String):
	if(handle_translation_conditionals(supply_id)):
		write_translation_text()
		update_translations.emit(translated_strings)

func handle_translation_conditionals(supply_id : String):
	var label = translation_data.label
	if(label.has("supplies") && label.supplies.has(supply_id)):
		return true
	var description = translation_data.description
	if(description.has("supplies") && description.supplies.has(supply_id)):
		return true
	return false

func get_translation_text() -> Dictionary:
	return translated_strings

func write_translation_text():
	translated_strings["label"] = translate_text(translation_data.label)
	if(translation_data.has("description")):
		var description = translation_data.description
		translated_strings["description"] = translate_text(description)

func translate_text(data: Dictionary) -> String:
	if(data.has("supplies")):
		var supply_ids : Array = data.supplies
		var supply_names = SupplyTranslatorSingle.get_supply_names(supply_ids)
		return data.text % supply_names
	else:
		return data.text

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

func set_complete():
	complete.emit()
	completed = true

func set_filter():
	filter_foreman.set_primary_filter(changes)

func unset_filter():
	filter_foreman.clear_primary_filter()

func gain_focus():
	filter_foreman.set_secondary_filter(changes)

func lose_focus():
	filter_foreman.clear_primary_filter()
