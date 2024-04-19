class_name Supply_Display extends Control

@export var name_label : RichTextLabel
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel

func set_id(id : String, supply_collection : Supply_Collection):
	set_name_display(id)
	var supply : Supply = supply_collection.get_supply(id)
	set_value_display(supply.value)
	supply.update_value.connect(set_value_display)
	set_max_display(supply.value)
	supply.update_max.connect(set_value_display)
	print(id)

func set_name_display(id : String):
	name_label.text = center(SupplyTranslatorSingle.data[id])

func set_value_display(value):
	value_label.text = center(str("%.2f" % value))

func set_max_display(value):
	max_label.text = center(str("%.2f" % value))

func set_delta_display(value):
	delta_label.text = center(str("%.2f" % value))

func center(text : String) -> String:
	return str("[center]", text, "[/center]")
