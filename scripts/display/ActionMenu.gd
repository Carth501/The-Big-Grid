class_name Action_Menu extends Control

signal close_action_menu

var action : Action
@export var supply_collection : Supply_Collection
@export var options_overseer : Options_Overseer
@export var machine_factory : Machine_Factory
@onready var machine_editor_prefab := preload("res://scenes/display/ActionMachineEditor.tscn")
@onready var supply_display_proto := preload("res://scenes/display/SupplyDisplay.tscn")
@export var action_machine_container : FlowContainer
@export var machine_purchase_button : Button
@export var tag_list_display : Tag_List_Display
@export var action_button : Action_Button
@export var supply_container : HBoxContainer
var idle_machine_editors : Array[Action_Machine_Editor] = []
var active_machine_editors : Array[Action_Machine_Editor] = []
var supply_displays := {}

func set_action(new_action : Action):
	action = new_action
	var machines = machine_factory.get_machines_by_id(action.id)
	for machine in machines:
		activate_machine_editor(machine)
	action.new_machine.connect(activate_machine_editor)
	if(action.automation_available):
		machine_purchase_button.visible = true
	else:
		machine_purchase_button.visible = false
	tag_list_display.set_target(action)
	
	action_button.set_id(action.id)
	action_button.connect_logic(action)
	action_button.change_label(ActionTranslatorSingle.data[action.id].name)
	
	for id in action.supplies:
		create_display(id)

func create_display(supply_id : String):
	var new_supply_display : Supply_Display = supply_display_proto.instantiate()
	supply_container.add_child(new_supply_display)
	new_supply_display.setup(supply_id, supply_collection, options_overseer)
	supply_displays[supply_id] = new_supply_display
	new_supply_display.show()

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

func attempt_machine_purchase():
	action.attempt_machine_purchase()

func close():
	action.new_machine.disconnect(activate_machine_editor)
	close_action_menu.emit()
	tag_list_display.close()
	action_button.disconnect_action()
	cleanup()

func cleanup():
	for editor in active_machine_editors:
		editor.close()
		idle_machine_editors.append(editor)
		editor.visible = false
	active_machine_editors.clear()
	for supply in supply_displays:
		supply_displays[supply].queue_free()
	supply_displays.clear()

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
