class_name Action_Menu extends Control

signal close
signal declare_changes(change : Dictionary)
signal end_filter
signal declare_focus(change : Dictionary)
signal end_focus

@export var action_name_label : Label
@export var resources : resource_pile
@export var purchase_machines_button : Button
@export var machine_factory : Machine_Factory
var action_machine_editors : Array
var change : Dictionary
var action_machines : Array
var action_id : String

func set_action(id : String):
	if(!ActionsSingle.data.has(id)):
		push_error(str("id ", id, " not found"))
		return
	action_id = id
	var action_definition = ActionsSingle.data[id]
	print(str(action_definition.has("automation_cost"), " ", action_definition))
	if(action_definition.has("automation_cost")):
		change = action_definition["automation_cost"]
		purchase_machines_button.visible = true
	else:
		purchase_machines_button.visible = false

func attempt_machine_purchase():
	var success = resources.attempt_purchase(change)
	if(!success):
		return
	machine_factory.build_machine(action_id)

func close_menu():
	close.emit()

func set_filter():
	declare_changes.emit(change)

func unset_filter():
	end_filter.emit()

func gain_focus():
	declare_focus.emit(change)

func lose_focus():
	end_focus.emit()
