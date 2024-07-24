class_name Action_Machine_Editor extends Control

@export var name_field : LineEdit
@export var op_rate_field : SpinBox
@export var active_switch : Button
@export var condition_list_container : VBoxContainer
@onready var condition_bar_prefab := preload("res://scenes/ConditionBar.tscn")
var machine : Machine

func set_machine(new_machine : Machine):
	machine = new_machine
	op_rate_field.value = machine.get_interval()
	machine.update_interval.connect(update_interval)
	update_running(machine.get_running())
	machine.update_active.connect(update_running)
	name_field.text = machine.name
	machine.update_name.connect(update_machine_name)
	for conditional in machine.conditionals:
		add_conditional(conditional)
	machine.new_conditional.connect(add_conditional)

func _ready() -> void:
	resize(null)

func close():
	machine.new_conditional.disconnect(add_conditional)
	machine.update_interval.disconnect(update_interval)
	machine.update_active.disconnect(update_running)
	machine.update_name.disconnect(update_machine_name)

func set_interval(value : float):
	machine.set_interval(value)

func update_interval(value : float):
	op_rate_field.value = value

func set_running(setting : bool):
	machine.set_running(setting)

func update_running(setting : bool):
	active_switch.button_pressed = setting

func set_machine_name(new_name : String = name_field.text):
	if(new_name != ""):
		machine.set_machine_name(new_name)

func update_machine_name(new_name : String):
	name_field.text = new_name

func request_additional_condition():
	machine.add_conditional()

func add_conditional(new_conditional : Conditional_Expression):
	var new_conditional_display = condition_bar_prefab.instantiate()
	condition_list_container.add_child(new_conditional_display)
	new_conditional_display.set_expression(new_conditional)

func resize(_node):
	var condition_count = condition_list_container.get_child_count()
	var vertical_length = 144 + condition_count * 49
	custom_minimum_size.y = vertical_length

func resize_minus_one(_node):
	var condition_count = condition_list_container.get_child_count() - 1
	var vertical_length = 144 + condition_count * 49
	custom_minimum_size.y = vertical_length
