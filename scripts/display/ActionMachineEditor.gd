class_name Action_Machine_Editor extends Panel

@export var name_field : LineEdit
@export var op_rate_field : SpinBox   
@export var condition_list_container : VBoxContainer
var condition_bar_path := "res://scenes/ConditionBar.tscn"
var machine : Machine

func set_machine(new_machine : Machine):
	machine = new_machine
	op_rate_field.value = machine.get_interval()
	name_field.text = machine.get_name()

func set_interval(value : float):
	machine.set_interval(value)

func set_running(setting : bool):
	machine.set_running(setting)

func set_machine_name(new_name : String):
	machine.set_name(new_name)
