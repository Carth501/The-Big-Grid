class_name Supply_Collection_Display extends HFlowContainer

@export var supply_collection : Supply_Collection
var supply_display_catalogue := {}
var supply_display_proto := preload("res://scenes/display/SupplyDisplay.tscn")

func _on_supply_collection_new_supply(id : String):
	var new_supply_display : Supply_Display = supply_display_proto.instantiate()
	add_child(new_supply_display)
	new_supply_display.set_id(id, supply_collection)
	supply_display_catalogue[id] = new_supply_display
