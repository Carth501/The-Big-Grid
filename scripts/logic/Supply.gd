class_name Supply extends Node

signal update_value(value : float)
signal new_delta(value : float)
signal update_max(v_max : float)
signal update_active
signal open_menu(supply)

var id := ""
var value := 0.0
var v_max := 20.0
var max_increment := 10.0
var max_upgrade_count := 0
var max_increase_base_cost : Dictionary
var active := false
var supply_collection : Supply_Collection
var filter_foreman : Filter_Foreman

func set_id(new_id : String):
	id = new_id
	var definition = SupplyDefsSingle.data[id]
	if(definition.has("default_value")):
		value = definition.default_value
	if(definition.has("default_max")):
		v_max = definition.default_max
	if(definition.has("max_increase_increment")):
		max_increment = definition.max_increase_increment
	if(definition.has("max_increase_base_cost")):
		max_increase_base_cost = definition.max_increase_base_cost

func set_collection(collection : Supply_Collection):
	supply_collection = collection

func set_filter_foreman(foreman : Filter_Foreman):
	filter_foreman = foreman

func test_deltas(deltas: Array) -> bool:
	var dummy_value = value
	for delta in deltas:
		dummy_value += delta
		if(dummy_value < 0 || dummy_value > v_max):
			return false
	return true

func apply_change(deltas: Array):
	for delta in deltas:
		value += delta
		new_delta.emit(delta)
	update_value.emit(value)

func activate():
	update_active.emit()
	active = true

func open():
	open_menu.emit(self)

func attempt_upgrade_max():
	var success = supply_collection.attempt_purchase(calculate_upgrade_cost())
	if(success):
		max_upgrade_count += 1
		v_max += max_increment
		update_max.emit(v_max)

func calculate_upgrade_cost() -> Dictionary:
	if(max_increase_base_cost == null || max_increase_base_cost == {}):
		return {}
	var count := max_upgrade_count + 1
	var cost = max_increase_base_cost.duplicate(true)
	for supply in cost:
		var supply_deltas = cost[supply].deltas
		for index in range(supply_deltas.size()):
			supply_deltas[index] *= count
	return cost

func set_upgrade_hover():
	filter_foreman.set_primary_filter(calculate_upgrade_cost())

func unset_upgrade_hover():
	filter_foreman.clear_primary_filter()

func set_upgrade_focus():
	filter_foreman.set_secondary_filter(calculate_upgrade_cost())

func unset_upgrade_focus():
	filter_foreman.clear_secondary_filter()

func set_name_override(new_name : String):
	SupplyTranslatorSingle.set_name_override(id, new_name)
