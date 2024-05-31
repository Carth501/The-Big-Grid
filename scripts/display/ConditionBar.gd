class_name Conditional_Bar extends Control

var supply_collection : Supply_Collection
var conditional_expression : Conditional_Expression
@export var left_member : Button
@export var left_member_icon : Supply_Icon_Display
@export var operation : OptionButton
@export var right_member : Button
@export var right_member_icon : Supply_Icon_Display

func _ready():
	supply_collection = Logic_Directory_Single.get_object("Supply_Collection")

func set_expression(new_conditional : Conditional_Expression):
	conditional_expression = new_conditional
	new_conditional.config_change.connect(update_expression_config)
	update_expression_config()

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
		left_member_icon.set_supply_name(supply.get_translation())
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
		right_member_icon.set_supply_name(supply.get_translation())
	else:
		clear_right()

func request_left_selection():
	conditional_expression.start_left_selection()

func request_right_selection():
	conditional_expression.start_right_selection()

func clear_left():
	left_member.text = ""
	left_member_icon.visible = false
	
func clear_right():
	right_member.text = ""
	right_member_icon.visible = false

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
