class_name Supply_Menu extends Control

signal close_supply_menu

@export var supply_name : LineEdit
@export var upgrade_increase : Label
@export var current_max_value : Label
@export var custom_max_spin : SpinBox
@export var max_upgrade_button : Button
@export var action_list : VBoxContainer
@export var action_manager : Action_Manager
@export var tag_list_display : Tag_List_Display
@onready var action_package := preload("res://scenes/display/ActionButton.tscn")
@onready var colored_number := preload("res://scenes/display/feedback/ColoredNumberDisplay.tscn")
var supply : Supply
var action_rows := {}

func open(new_supply : Supply):
	supply = new_supply
	current_max_value.text = str("%.2f" % supply.v_max)
	if(supply.max_upgrade_available):
		max_upgrade_button.visible = true
		upgrade_increase.text = str("%.2f" % supply.max_increment)
	else:
		max_upgrade_button.visible = false
		upgrade_increase.text = ""
	var action_options = action_manager.get_actions_with_supply(supply.id)
	for action_id in action_rows:
		if(action_options.has(action_id)):
			action_rows[action_id].visible = true
		else:
			action_rows[action_id].visible = false
	for action_option in action_options:
		add_action_to_list(action_option)
	tag_list_display.set_supply(supply)

func close():
	close_supply_menu.emit()
	tag_list_display.close()

func change_supply_name(new_name : String):
	supply.set_name_override(new_name)

func update_supply_name(current_name : String):
	if(supply_name.text != current_name):
		supply_name.text = current_name

func attempt_max_upgrade():
	supply.attempt_upgrade_max()

func upgrade_enter():
	supply.set_upgrade_hover()

func upgrade_exit():
	supply.unset_upgrade_hover()

func upgrade_focus():
	supply.set_upgrade_focus()

func upgrade_unfocus():
	supply.unset_upgrade_focus()

func add_action_to_list(id : String):
	if(action_rows.has(id)):
		return
	if(!ActionsSingle.data.has(id)):
		push_error(str("id ", id, " not found"))
		return
	var new_row := HBoxContainer.new()
	action_list.add_child(new_row)
	action_rows[id] = new_row
	var new_button : Action_Button = action_package.instantiate()
	new_button.set_id(id)
	new_row.add_child(new_button)
	if(!ActionTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	var action_logic = action_manager.full_action_list[id]
	new_button.connect_logic(action_logic)
	var deltas = action_logic.changes[supply.id].deltas
	var new_label = create_action_net_delta(deltas)
	new_row.add_child(new_label)
	new_label.position.x += new_button.size.x

func create_action_net_delta(deltas : Array) -> Label:
	var net := 0
	for delta in deltas:
		net += delta
	var new_label : Colored_Number_Display = colored_number.instantiate()
	new_label.set_number(net)
	return new_label
