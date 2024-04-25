class_name Action_Menu extends Control

signal close_action_menu

var action : Action
@export var action_name_label : Label

func set_action(new_action : Action):
	action = new_action
	action_name_label.text = action.get_translation_text()

func close():
	close_action_menu.emit()

func set_filter():
	action.set_filter()

func unset_filter():
	action.unset_filter()

func gain_focus():
	action.gain_focus()

func lose_focus():
	action.lose_focus()
