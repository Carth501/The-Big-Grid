class_name Action_Machine_Editor extends Panel

@export var name_field : LineEdit
@export var op_rate_field : SpinBox   
@export var condition_list_container : VBoxContainer
@onready var condition_bar_prefab := preload("res://scenes/ConditionBar.tscn")
var machine : Machine
var conditional_bars : Array = []

func set_machine(new_machine : Machine):
	machine = new_machine
	op_rate_field.value = machine.get_interval()
	name_field.text = machine.get_name()
	machine.new_conditional.connect(add_conditional)

func close():
	machine.new_conditional.disconnect(add_conditional)

func set_interval(value : float):
	machine.set_interval(value)

func set_running(setting : bool):
	machine.set_running(setting)

func set_machine_name(new_name : String):
	machine.set_name(new_name)

func request_additional_condition():
	machine.add_conditional()

func add_conditional(new_conditional : Conditional_Expression):
	var new_conditional_display = condition_bar_prefab.instantiate()
	new_conditional_display.set_expression(new_conditional)
	condition_list_container.add_child(new_conditional_display)
