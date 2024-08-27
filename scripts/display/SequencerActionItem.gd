class_name Sequencer_Action_Item extends Control

var action : Action
@export var action_controls : Control
@export var empty_button : Button
@export var action_button : Action_Button

func set_action(new_action : Action):
	action = new_action
	if(action == null):
		empty_button.visible = true
		action_controls.visible = false
		return
	else:
		empty_button.visible = false
		action_controls.visible = true
		action_button.set_id(action.id)
		action_button.connect_logic(action)
