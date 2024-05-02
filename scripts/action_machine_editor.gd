class_name Action_Machine_Editor extends Panel

@export var op_rate_field : SpinBox
@export var max_label : Label
@export var condition_list_container : VBoxContainer
var condition_bar_path := "res://scenes/ConditionBar.tscn"
var machine : Machine

func set_machine(new_machine : Machine):
	machine = new_machine
