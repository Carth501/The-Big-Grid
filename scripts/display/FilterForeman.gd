class_name Filter_Foreman extends Node

signal update_filter(filter : Dictionary)

@export var supply_collection : Supply_Collection
var primary_filter : Dictionary
var secondary_filter : Dictionary
var secondary_filter_enabled := true
var search_term : String

func set_primary_filter(filter : Dictionary):
	primary_filter = filter
	choose_filter()
	
func set_secondary_filter(filter : Dictionary):
	secondary_filter = filter
	choose_filter()

func clear_primary_filter():
	primary_filter = {}
	choose_filter()

func clear_secondary_filter():
	secondary_filter = {}
	choose_filter()

func choose_filter():
	if(primary_filter != {}):
		var filter = concatenate_search_filter(primary_filter)
		apply_filter(filter)
	elif(secondary_filter != {} && secondary_filter_enabled):
		var filter = concatenate_search_filter(secondary_filter)
		apply_filter(filter)
	elif(search_term != null && search_term != ""):
		var all_supplies = supply_collection.get_all_supply_ids()
		var filter = filter_search_exclusive(all_supplies)
		apply_filter(filter)
	else:
		apply_filter({})

func concatenate_search_filter(filter : Dictionary) -> Dictionary:
	if(search_term == null || search_term == ""):
		return filter
	var new_filter = {}
	for supply_id in filter:
		var supply_name = SupplyTranslatorSingle.get_supply_name(supply_id)
		if(supply_name.to_lower().contains(search_term.to_lower())):
			new_filter[supply_id] = filter[supply_id]
	if(new_filter == {}):
		new_filter["bad_filter"] = true
	return new_filter

func filter_search_exclusive(id_list : Array[String]) -> Dictionary:
	var new_filter = {}
	for id in id_list:
		var supply_name = SupplyTranslatorSingle.get_supply_name(id)
		if(supply_name.to_lower().contains(search_term.to_lower())):
			new_filter[id] = {}
	if(new_filter == {}):
		new_filter["bad_filter"] = true
	return new_filter

func apply_filter(filter : Dictionary):
	update_filter.emit(filter)

func set_secondary_filter_active(setting : bool):
	secondary_filter_enabled = setting

func set_search_filter(new_search_term : String):
	search_term = new_search_term
	choose_filter()
