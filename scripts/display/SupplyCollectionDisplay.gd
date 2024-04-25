class_name Supply_Collection_Display extends HFlowContainer

@export var supply_collection : Supply_Collection
var supply_display_catalogue := {}
var supply_display_proto := preload("res://scenes/display/SupplyDisplay.tscn")

func _on_supply_collection_new_supply(id : String):
	var new_supply_display : Supply_Display = supply_display_proto.instantiate()
	add_child(new_supply_display)
	new_supply_display.setup(id, supply_collection)
	supply_display_catalogue[id] = new_supply_display

func filter(new_filter : Dictionary):
	if(new_filter == {}):
		for supply_display_id in supply_display_catalogue:
			var supply_display = supply_display_catalogue[supply_display_id]
			supply_display.show_supply(true)
			supply_display.clear_delta_display()
	else:
		for supply_display_id in supply_display_catalogue:
			var supply_display = supply_display_catalogue[supply_display_id]
			if(new_filter.has(supply_display_id)):
				supply_display.show_supply(true)
				var deltas = new_filter[supply_display_id].deltas
				supply_display.set_delta_display(deltas)
			else:
				supply_display.show_supply(false)
				supply_display.clear_delta_display()
