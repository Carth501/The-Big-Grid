class_name Supply_Display extends Control

@export var supply_icon_display : Supply_Icon_Display
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel
@export var supply_button : Button
@export var supply_change_feedback : Supply_Change_Feedback
@export var supply_curtain : Panel
var supply : Supply
var showing := true
var static_position := true

func setup(id : String, 
supply_collection : Supply_Collection, 
options_overseer : Options_Overseer):
	supply = supply_collection.get_supply(id)
	# don't use the function for updating value, because it should start hidden.
	value_label.text = center(str("%.1f" % supply.value)) 
	supply.update_value.connect(set_value_display)
	supply.new_delta.connect(add_new_delta)
	set_max_display(supply.v_max)
	supply.update_max.connect(set_max_display)
	if(supply.active):
		set_active()
	else:
		supply.update_active.connect(set_active)
	options_overseer.update_keep_positions.connect(set_static_position)
	set_icon_display(supply)

func set_icon_display(supply : Supply):
	supply_icon_display.set_image_by_path(supply.supply_icon_path)
	supply_icon_display.set_supply_name(supply.get_translation())

func set_value_display(value : float):
	value_label.text = center(str("%.1f" % value))

func add_new_delta(value : float):
	supply_change_feedback.new_delta(value)

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
	supply_curtain.visible = false

func show_supply(setting : bool):
	showing = setting
	if(static_position):
		supply_button.visible = showing
	else:
		visible = showing

func set_static_position(setting : bool):
	static_position = setting
	if(!showing):
		if(static_position):
			visible = true
			supply_button.visible = false
		else:
			visible = false
			supply_button.visible = true

func select():
	supply.trigger_select()

func open_menu():
	supply.open()
