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
@export var supply_label : Supply_Label
var supply : Supply
var revealed := false
var filtered_mode := false
var in_filter := true
var static_position := true
var supply_name : String
var supply_description : String
var hovering := false

func setup(id : String, 
supply_collection : Supply_Collection, 
options_overseer : Options_Overseer):
	if(supply != null):
		if(supply.id == id):
			return
		else:
			disconnect_everything()
	supply = supply_collection.get_or_create_supply(id)
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

func _input(event: InputEvent) -> void:
	if(!hovering):
		return
	if event.is_action_pressed("delete"):
		supply.open_empty_confirmation()

func set_icon_display():
	if(supply.supply_icon_path != null && supply.supply_icon_path != ""):
		supply_icon_display.set_image_by_path(supply.supply_icon_path)
	else:
		var unknown = "res://textures/Supply_Icons/Unknown.png"
		supply_icon_display.set_image_by_path(unknown)
	var localization = supply.get_translation()
	supply_name = localization.name
	supply_description = localization.description

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

func set_objective(obj_def : Dictionary):
	objective_star.visible = true
	objective_star.set_objective_conditions(obj_def)

func unset_objective():
	objective_star.visible = false

func show_label():
	hovering = true
	if(supply_label == null):
		supply_label = get_node("/root/Game/SupplyLabel")
	supply_label.show_name(supply_name)
	supply_label.move_to_supply_rect(get_global_rect())
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.update_text("RMB: Open supply menu")

func hide_label():
	hovering = false
	supply_label.hide_name()
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.clear_text()

func show_description():
	supply_label.show_description(supply_description)
	supply_label.move_to_supply_rect(get_global_rect())

func hide_description():
	supply_label.hide_description()

func set_label(new_supply_label : Supply_Label):
	supply_label = new_supply_label

func disconnect_everything():
	supply.reveal_this.disconnect(reveal)
	supply.update_value.disconnect(set_value_display)
	supply.new_delta.disconnect(add_new_delta)
	supply.update_max.disconnect(set_max_display)
	supply.set_obj.disconnect(set_objective)
	supply.unset_obj.disconnect(unset_objective)
