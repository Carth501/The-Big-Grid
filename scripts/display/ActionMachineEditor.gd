class_name Action_Machine_Editor extends Control

@export var name_field : LineEdit
@export var op_rate_field : SpinBox
@export var active_switch : Button
@export var condition_list_container : VBoxContainer
@export var tier_value : Label
@onready var condition_bar_prefab := preload("res://scenes/ConditionBar.tscn")
var machine : Machine
var hovering := false
@export var progress_bar : ProgressBar
var progressing := true
var progress_value := 0.0

func _input(event: InputEvent) -> void:
	if(hovering):
		if event.is_action_pressed("copy"):
			shift_right_click()
		elif event.is_action_pressed("paste"):
			shift_left_click()

func set_machine(new_machine : Machine):
	machine = new_machine
	op_rate_field.value = machine.get_interval()
	machine.update_interval.connect(update_interval)
	var active = machine.get_running()
	update_running(active)
	machine.update_active.connect(update_running)
	name_field.text = machine.name
	machine.update_name.connect(update_machine_name)
	for conditional in machine.conditionals:
		add_conditional(conditional)
	machine.new_conditional.connect(add_conditional)
	update_tier_value(machine.tier)
	machine.update_tier.connect(update_tier_value)
	machine.next_time.connect(set_progress_bar)
	machine.update_interval.connect(change_progress_bar_time)

func _ready() -> void:
	resize(null)

func close():
	machine.new_conditional.disconnect(add_conditional)
	machine.update_interval.disconnect(update_interval)
	machine.update_active.disconnect(update_running)
	machine.update_name.disconnect(update_machine_name)
	machine.update_tier.disconnect(update_tier_value)
	machine.next_time.disconnect(set_progress_bar)
	machine.update_interval.disconnect(change_progress_bar_time)

func set_interval(value : float):
	machine.set_interval(value)

func update_interval(value : float):
	op_rate_field.value = value

func set_running(setting : bool):
	machine.set_running(setting)

func update_running(setting : bool):
	active_switch.set_pressed_no_signal(setting)

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
	var vertical_length = 200 + condition_count * 96
	custom_minimum_size.y = vertical_length

func resize_minus_one(_node):
	var condition_count = condition_list_container.get_child_count() - 1
	var vertical_length = 200 + condition_count * 96
	custom_minimum_size.y = vertical_length

func hover_upgrade():
	machine.preview_upgrade_costs()

func leave_upgrade():
	machine.end_upgrade_preview()

func attempt_machine_upgrade():
	machine.attempt_machine_upgrade()

func update_tier_value(new_value : int):
	tier_value.text = str(new_value)

func shift_right_click():
	machine.attempt_copy()

func shift_left_click():
	machine.attempt_paste()

func enter_hovering():
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.update_text("Shift-RMB: Copy, Shift-LMB: Paste")
	hovering = true

func exit_hovering():
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.clear_text()
	hovering = false

func _process(delta: float) -> void:
	if(progressing):
		progress_value += delta
		progress_bar.value = progress_value

func set_progress_bar(duration):
	progress_bar.max_value = duration
	progress_value = 0

func change_progress_bar_time(duration):
	progress_bar.max_value = duration
