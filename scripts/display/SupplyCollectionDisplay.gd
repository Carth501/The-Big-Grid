class_name Supply_Collection_Display extends HFlowContainer

@export var supply_collection : Supply_Collection
@export var options_overseer : Options_Overseer
@export var supply_label : Supply_Label
var supply_display_catalogue := {}
var supply_display_proto := preload("res://scenes/display/SupplyDisplay.tscn")

func _on_supply_collection_new_supply(id : String):
	var new_supply_display : Supply_Display = supply_display_proto.instantiate()
	add_child(new_supply_display)
	new_supply_display.setup(id, supply_collection, options_overseer)
	supply_display_catalogue[id] = new_supply_display
	new_supply_display.set_label(supply_label)
	var supply_data = SupplyDefsSingle.data[id]
	if(supply_data.has("default_index")):
		if(supply_data.default_index + 1 < get_child_count()):
			move_child(new_supply_display, supply_data.default_index + 1)

func filter(new_filter : Dictionary):
	if(new_filter.has("bad_filter") && new_filter.bad_filter):
		push_error("bad_filter passed to supply collection display")
		for supply_display_id in supply_display_catalogue:
			var supply_display = supply_display_catalogue[supply_display_id]
			supply_display.set_filtered_mode(true)
			supply_display.clear_delta_display()
	elif(new_filter == {}):
		for supply_display_id in supply_display_catalogue:
			var supply_display = supply_display_catalogue[supply_display_id]
			supply_display.set_filtered_mode(false)
			supply_display.clear_delta_display()
	else:
		for supply_display_id in supply_display_catalogue:
			var supply_display = supply_display_catalogue[supply_display_id]
			supply_display.set_filtered_mode(true)
			if(new_filter.has(supply_display_id)):
				supply_display.set_in_filter(true)
				if(new_filter[supply_display_id].has("deltas")):
					var deltas = new_filter[supply_display_id].deltas
					supply_display.set_delta_display(deltas)
				else:
					supply_display.clear_delta_display()
			else:
				supply_display.set_in_filter(false)
				supply_display.clear_delta_display()
