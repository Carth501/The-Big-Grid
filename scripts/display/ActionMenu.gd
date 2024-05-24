class_name Action_Menu extends Control

signal close_action_menu

var action : Action
@export var action_name_label : Label
@export var machine_factory : Machine_Factory
@onready var machine_editor_prefab := preload("res://scenes/display/ActionMachineEditor.tscn")
@export var action_machine_container : FlowContainer
@export var machine_purchase_button : Button
var idle_machine_editors : Array[Action_Machine_Editor] = []
var active_machine_editors : Array[Action_Machine_Editor] = []

func set_action(new_action : Action):
	action = new_action
	set_label_text(action.get_translation_text())
	action.update_action_name.connect(set_label_text)
	var machines = machine_factory.get_machines_by_id(action.id)
	for machine in machines:
		activate_machine_editor(machine)
	action.new_machine.connect(activate_machine_editor)
	if(action.automation_available):
		machine_purchase_button.visible = true
	else:
		machine_purchase_button.visible = false

func activate_machine_editor(new_machine : Machine):
	var editor = get_idle_machine_editor()
	editor.visible = true
	active_machine_editors.append(editor)
	editor.set_machine(new_machine)

func get_idle_machine_editor() -> Action_Machine_Editor:
	if(idle_machine_editors.size() > 0):
		return idle_machine_editors.pop_front()
	else:
		var new_machine = machine_editor_prefab.instantiate()
		action_machine_container.add_child(new_machine)
		return new_machine

func set_label_text(action_name : String):
	action_name_label.text = action_name

func attempt_machine_purchase():
	action.attempt_machine_purchase()

func close():
	action.update_action_name.disconnect(set_label_text)
	action.new_machine.disconnect(activate_machine_editor)
	close_action_menu.emit()
	cleanup()

func cleanup():
	for editor in active_machine_editors:
		editor.close()
		idle_machine_editors.append(editor)
		editor.visible = false
	active_machine_editors.clear()

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
