class_name Action_Panel extends Control

@onready var action_package := preload("res://scenes/display/ActionButton.tscn")
@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
@export var sequencer_manager : Sequencer_Manager
@export var hotkey_controller : Hotkey_Controller
var action_buttons := {}

func build_action_button(id : String):
	if(action_buttons.has(id)):
		push_error(str("action button already exists for ", id))
		return
	if(!ActionsSingle.data.has(id)):
		push_error(str("id ", id, " not found"))
		return
	var new_button : Action_Button = action_package.instantiate()
	new_button.set_id(id)
	add_child(new_button)
	if(!ActionTranslatorSingle.data.has(id)):
		push_error(str("id ", id, " translation not found"))
		return
	action_buttons[id] = new_button
	var action_logic = action_manager.full_action_list[id]
	new_button.connect_logic(action_logic)
	new_button.select.connect(select)
	new_button.selection_hover.connect(selection_hover)
	new_button.end_selection_hover.connect(end_selection_hover)
	new_button.register_hotkey_controller(hotkey_controller)

func filter_actions(id_list : Array):
	for id in action_buttons:
		if(id_list.has(id)):
			action_buttons[id].visible = true
		else:
			action_buttons[id].visible = false

func enter_selection_mode():
	for action_button_key in action_buttons:
		action_buttons[action_button_key].selection_mode = true

func exit_selection_mode():
	for action_button_key in action_buttons:
		action_buttons[action_button_key].selection_mode = false

func select(action: Action):
	sequencer_manager.fufill_request(action)
	exit_selection_mode()

func selection_hover(action: Action):
	sequencer_manager.set_selection_hover(action)

func end_selection_hover():
	sequencer_manager.end_selection_hover()
