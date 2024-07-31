class_name Supply_Display extends Control

signal opening_menu
@export var supply_icon_display : Supply_Icon_Display
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel
@export var supply_button : Button
@export var supply_change_feedback : Supply_Change_Feedback
@export var supply_curtain : Panel
@export var objective_star : Objective_Star
@export var supply_warning : Supply_Warning
@export var popup_container : PanelContainer
@export var popup_label : Label
@export var popup_description : Label
var supply : Supply
var revealed := false
var filtered_mode := false
var in_filter := true
var static_position := true

func setup(id : String, 
supply_collection : Supply_Collection, 
options_overseer : Options_Overseer):
	supply = supply_collection.get_supply(id)
	supply.reveal_this.connect(reveal)
	value_label.text = center(str("%.1f" % supply.value)) 
	supply.update_value.connect(set_value_display)
	supply.new_delta.connect(add_new_delta)
	set_max_display(supply.v_max)
	supply.update_max.connect(set_max_display)
	supply.set_obj.connect(set_objective)
	supply.unset_obj.connect(unset_objective)
	if(supply.active):
		set_active()
	else:
		supply.update_active.connect(set_active)
	options_overseer.update_keep_positions.connect(set_static_position)
	set_icon_display()
	if(supply.degrade > 0):
		supply_warning.visible = true
		var warning_num = (1.0 - supply.degrade) * 100
		var warning_text = str("This resource degrades ", warning_num, "%.")
		supply_warning.add_text(warning_text)
	visible = revealed

func set_icon_display():
	if(supply.supply_icon_path != null && supply.supply_icon_path != ""):
		supply_icon_display.set_image_by_path(supply.supply_icon_path)
	var localization = supply.get_translation()
	set_supply_name(localization.name)
	set_supply_description(localization.description)


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

func reveal():
	revealed = true
	handle_visibility()

func set_filtered_mode(setting : bool):
	filtered_mode = setting
	handle_visibility()

func set_in_filter(setting : bool):
	in_filter = setting
	handle_visibility()

func set_static_position(setting : bool):
	static_position = setting
	handle_visibility()

func handle_visibility():
	var showing = false
	if(!filtered_mode && revealed):
		showing = true
	if(filtered_mode && in_filter):
		showing = true
	if(showing):
		visible = true
		supply_button.visible = true
	else:
		if(static_position):
			visible = true
			supply_button.visible = false
		else:
			visible = false
			supply_button.visible = true

func select():
	supply.trigger_select()

func open_menu():
	opening_menu.emit()
	supply.open()

func set_objective(obj_def : Array):
	objective_star.visible = true
	objective_star.set_objective_conditions(obj_def)

func unset_objective():
	objective_star.visible = false

func set_supply_name(new_name : String):
	popup_label.text = new_name

func set_supply_description(description : String):
	popup_description.text = description

func show_label():
	popup_container.visible = true

func hide_label():
	popup_container.visible = false

func show_description():
	popup_description.visible = true

func hide_description():
	popup_description.visible = false
