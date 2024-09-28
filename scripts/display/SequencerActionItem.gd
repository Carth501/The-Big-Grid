class_name Sequencer_Action_Item extends Control

signal remove(index)
signal begin_fill(index)

var action : Action
@export var action_controls : Control
@export var empty_button : Button
@export var action_button : Action_Button
@export var number_label : Label
var index : int

func set_action(new_action : Action):
	if(new_action == null):
		empty_button.visible = true
		action_controls.visible = false
		if(action != null):
			action_button.disconnect_action()
		return
	else:
		empty_button.visible = false
		action_controls.visible = true
		action_button.set_id(new_action.id)
		var hotkey_controller = Logic_Directory_Single.get_object("Hotkey_Controller")
		action_button.register_hotkey_controller(hotkey_controller)
	action = new_action

func set_index(value : int):
	index = value
	number_label.text = str(index + 1)

func remove_action():
	remove.emit(index)

func begin_slot_fill():
	begin_fill.emit(index)
