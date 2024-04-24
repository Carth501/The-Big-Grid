class_name Supply_Display extends Control

@export var name_label : RichTextLabel
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel
@export var supply_button : Button
var supply : Supply
var active := false

func setup(id : String, supply_collection : Supply_Collection):
	set_name_display(id)
	supply = supply_collection.get_supply(id)
	# don't use the function for updating value, because it should start hidden.
	value_label.text = center(str("%.2f" % supply.value)) 
	supply.update_value.connect(set_value_display)
	set_max_display(supply.v_max)
	supply.update_max.connect(set_max_display)
	supply_button.visible = false
	active = supply.active
	if(!active):
		supply.update_active.connect(set_active)

func set_name_display(id : String):
	name_label.text = center(SupplyTranslatorSingle.data[id])

func set_value_display(value):
	value_label.text = center(str("%.1f" % value))

func set_max_display(value):
	max_label.text = center(str("%.1f" % value))

func set_delta_display(values : Array):
	var value_string = ""
	for value in values:
		value_string += str("%+.1f" % value)
	delta_label.text = center(value_string)

func clear_delta_display():
	delta_label.text = ""

func center(text : String) -> String:
	return str("[center]", text, "[/center]")

func set_active():
	active = true
	show_supply(true)

func show_supply(setting : bool):
	if(active):
		supply_button.visible = setting
