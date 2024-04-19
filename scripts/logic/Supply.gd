class_name Supply extends Node

signal update_value(value : float)
signal update_max(v_max : float)

var id := ""
var value := 0.0
var v_max := 20.0
var max_increment := 10.0
var max_upgrade_count := 0
var max_increase_base_cost : Dictionary

func set_id(new_id : String):
	id = new_id

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
