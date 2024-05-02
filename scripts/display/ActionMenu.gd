class_name Action_Menu extends Control

signal close_action_menu

var action : Action
@export var action_name_label : Label
@onready var machine_editor_prefab := preload("res://scenes/ActionMachineEditor.tscn")

func set_action(new_action : Action):
	action = new_action
	set_label_text(action.get_translation_text())
	action.update_action_name.connect(set_label_text)

func set_label_text(action_name : String):
	action_name_label.text = action_name

func attempt_machine_purchase():
	action.attempt_machine_purchase()

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

func set_filter_machine():
	action.set_machine_purchase_filter()

func gain_focus_machine():
	action.gain_machine_purchase_focus()
