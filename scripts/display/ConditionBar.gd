class_name Conditional_Bar extends Control

var supply_collection : Supply_Collection
var conditional_expression : Conditional_Expression
@export var left_member : Button
@export var left_member_icon : Supply_Icon_Display
@export var operation : OptionButton
@export var right_member : Button
@export var right_member_icon : Supply_Icon_Display
var supply_label : Supply_Label

func _ready():
	supply_collection = Logic_Directory_Single.get_object("Supply_Collection")
	left_member_icon.index = 0
	right_member_icon.index = 1

func set_expression(new_conditional : Conditional_Expression):
	conditional_expression = new_conditional
	new_conditional.config_change.connect(update_expression_config)
	update_expression_config()
	conditional_expression.delete_this.connect(remove)
	conditional_expression.end_changing.connect(hide_control_instructions)

func update_expression_config():
	var config = conditional_expression.configuration
	if(config.has("left")):
		write_left_member(config.left)
	else:
		clear_left()
	if(config.has("right")):
		write_right_member(config.right)
	else:
		clear_right()
	var comparator = conditional_expression.comparator
	if(comparator == conditional_expression.Comparators.GREATER):
		operation.select(0)
	elif(comparator == conditional_expression.Comparators.EQUAL):
		operation.select(1)
	elif(comparator == conditional_expression.Comparators.LESS):
		operation.select(2)
	

func write_left_member(left_config : Dictionary):
	if(left_config.has("constant")):
		left_member.text = left_config.constant
		left_member_icon.visible = false
	elif(left_config.has("variable")):
		left_member.text = ""
		left_member_icon.visible = true
		var supply = supply_collection.get_supply(left_config.variable)
		left_member_icon.set_image_by_path(supply.supply_icon_path)
	else:
		clear_left()

func write_right_member(right_config : Dictionary):
	if(right_config.has("constant")):
		right_member.text = right_config.constant
		right_member_icon.visible = false
	elif(right_config.has("variable")):
		right_member.text = ""
		right_member_icon.visible = true
		var supply = supply_collection.get_supply(right_config.variable)
		right_member_icon.set_image_by_path(supply.supply_icon_path)
	else:
		clear_right()

func request_left_selection():
	conditional_expression.start_left_selection()
	display_control_instructions()

func request_right_selection():
	conditional_expression.start_right_selection()
	display_control_instructions()

func clear_left():
	left_member.text = ""
	left_member_icon.visible = false
	
func clear_right():
	right_member.text = ""
	right_member_icon.visible = false

func delete():
	if(conditional_expression == null):
		push_error("Attempted deletion of condition, but the expression is null")
	conditional_expression.delete()
	queue_free()

func remove(_conditional_expression):
	queue_free()

func set_comparator(new_value : int):
	var comparator = conditional_expression.Comparators.EQUAL
	if(new_value == 0):
		comparator = conditional_expression.Comparators.GREATER
	elif(new_value == 1):
		comparator = conditional_expression.Comparators.EQUAL
	elif(new_value == 2):
		comparator = conditional_expression.Comparators.LESS
	else:
		push_warning("unknown comparator value")
	conditional_expression.set_comparator(comparator)

func display_control_instructions():
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.set_priority_text(
			"LMB over a supply to add it to the conditional. ESC to cancel."
			)

func hide_control_instructions():
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.clear_priority_text()

func show_label(index : int):
	if(supply_label == null):
		supply_label = get_node("/root/Game/SupplyLabel")
	var supply_id : String
	var config = conditional_expression.configuration
	if(index == 0):
		if(config.has("left")):
			if(config.left.has("variable")):
				supply_id = config.left.variable
			else:
				return
			var member_rect = left_member_icon.get_global_rect()
			supply_label.move_to_supply_rect(member_rect)
		else:
			return
	elif(index == 1):
		if(config.has("right")):
			if(config.right.has("variable")):
				supply_id = config.right.variable
			else:
				return
			var member_rect = right_member_icon.get_global_rect()
			supply_label.move_to_supply_rect(member_rect)
		else:
			return
	var supply = supply_collection.get_supply(supply_id)
	var localization = supply.get_translation()
	supply_label.show_name(localization.name)

func hide_label():
	supply_label.hide_name()
