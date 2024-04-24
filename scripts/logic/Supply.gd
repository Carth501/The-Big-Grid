class_name Supply extends Node

signal update_value(value : float)
signal update_max(v_max : float)
signal update_active

var id := ""
var value := 0.0
var v_max := 20.0
var max_increment := 10.0
var max_upgrade_count := 0
var max_increase_base_cost : Dictionary
var active := false

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
	update_value.emit(value)

func activate():
	print(str("activating ", id))
	update_active.emit()
	active = true
