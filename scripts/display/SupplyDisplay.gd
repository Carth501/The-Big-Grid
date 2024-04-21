class_name Supply_Display extends Control

@export var name_label : RichTextLabel
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel
@export var supply_button : Button
var active := false

func setup(id : String, supply_collection : Supply_Collection):
	set_name_display(id)
	var supply : Supply = supply_collection.get_supply(id)
	# don't use the function for updating value, because it should start hidden.
	value_label.text = center(str("%.2f" % supply.value)) 
	supply.update_value.connect(set_value_display)
	set_max_display(supply.v_max)
	supply.update_max.connect(set_max_display)
	print(id)

func set_name_display(id : String):
	name_label.text = center(SupplyTranslatorSingle.data[id])

func set_value_display(value):
	set_active(true)
	value_label.text = center(str("%.2f" % value))

func set_max_display(value):
	max_label.text = center(str("%.2f" % value))

func set_delta_display(value):
	delta_label.text = center(str("%.2f" % value))

func center(text : String) -> String:
	return str("[center]", text, "[/center]")

func set_active(setting : bool):
	if(active != setting):
		active = setting
		supply_button.visible = active
