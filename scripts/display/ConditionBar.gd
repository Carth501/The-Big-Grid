class_name Conditional_Bar extends Control

var supply_collection : Supply_Collection
var conditional_expression : Conditional_Expression
@export var left_member : Button
@export var left_member_icon : Supply_Icon_Display
@export var left_member_const : Label
@export var operation : OptionButton
@export var right_member : Button
@export var right_member_icon : Supply_Icon_Display
@export var right_member_const : Label
var supply_label : Supply_Label
var constant_config_popup : Constant_Config_Popup

func _ready():
	supply_collection = Logic_Directory_Single.get_object("Supply_Collection")
	supply_label = get_node("/root/Game/SupplyLabel")
	constant_config_popup = get_node("/root/Game/ConstantConfigPopup")

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
		left_member_icon.visible = false
		left_member_const.visible = true
	elif(left_config.has("variable")):
		left_member_icon.visible = true
		left_member_const.visible = false
		var supply = supply_collection.get_supply(left_config.variable)
		left_member_icon.set_image_by_path(supply.supply_icon_path)
	else:
		clear_left()
	constant_config_popup.close()
	var const_func = constant_config_popup.new_constant
	if(const_func.is_connected(conditional_expression.set_left_constant)):
		const_func.disconnect(conditional_expression.set_left_constant)

func write_right_member(right_config : Dictionary):
	if(right_config.has("constant")):
		right_member_icon.visible = false
		right_member_const.visible = true
	elif(right_config.has("variable")):
		right_member_icon.visible = true
		right_member_const.visible = false
		var supply = supply_collection.get_supply(right_config.variable)
		right_member_icon.set_image_by_path(supply.supply_icon_path)
	else:
		clear_right()
	constant_config_popup.close()
	var const_func = constant_config_popup.new_constant
	if(const_func.is_connected(conditional_expression.set_right_constant)):
		const_func.disconnect(conditional_expression.set_right_constant)

func request_left_selection():
	conditional_expression.start_left_selection()
	display_control_instructions()
	hide_label()
	var config = conditional_expression.configuration
	if(config.has("right")):
		if(config.right.has("variable")):
			var supply_id = config.right.variable
			var supply = supply_collection.get_supply(supply_id)
			var max_value = supply.v_max
			if(config.has("left") && config.left.has("constant")):
				var value = config.left.constant
				constant_config_popup.open(value, max_value, false)
			else:
				constant_config_popup.open(0, max_value, false)
	else:
		constant_config_popup.open(0, 0, true)
	set_popup_pos(left_member)
	var const_func = constant_config_popup.new_constant
	if(const_func.is_connected(conditional_expression.set_right_constant)):
		const_func.disconnect(conditional_expression.set_right_constant)
	if(!const_func.is_connected(conditional_expression.set_left_constant)):
		const_func.connect(conditional_expression.set_left_constant)

func request_right_selection():
	conditional_expression.start_right_selection()
	display_control_instructions()
	hide_label()
	var config = conditional_expression.configuration
	if(config.has("left")):
		if(config.left.has("variable")):
			var supply_id = config.left.variable
			var supply = supply_collection.get_supply(supply_id)
			var max_value = supply.v_max
			if(config.has("right") && config.right.has("constant")):
				var value = config.right.constant
				constant_config_popup.open(value, max_value, false)
			else:
				constant_config_popup.open(0, max_value, false)
	else:
		constant_config_popup.open(0, 0, true)
	set_popup_pos(right_member)
	var const_func = constant_config_popup.new_constant
	if(const_func.is_connected(conditional_expression.set_left_constant)):
		const_func.disconnect(conditional_expression.set_left_constant)
	if(!const_func.is_connected(conditional_expression.set_right_constant)):
		const_func.connect(conditional_expression.set_right_constant)

func clear_left():
	left_member_icon.visible = false
	left_member_const.visible = false
	
func clear_right():
	right_member_icon.visible = false
	right_member_const.visible = false

func delete():
	if(conditional_expression == null):
		push_error("Attempted deletion of condition, but the expression is null")
	conditional_expression.delete()
	queue_free()
	var const_func = constant_config_popup.new_constant
	if(const_func.is_connected(conditional_expression.set_right_constant)):
		const_func.disconnect(conditional_expression.set_right_constant)
	if(const_func.is_connected(conditional_expression.set_left_constant)):
		const_func.disconnect(conditional_expression.set_left_constant)

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

func show_left_popup():
	var config = conditional_expression.configuration
	if(config.has("left")):
		if(config.left.has("variable")):
			var supply = supply_collection.get_supply(config.left.variable)
			var localization = supply.get_translation()
			supply_label.show_name(localization.name)
		elif(config.left.has("constant")):
			supply_label.show_name(str(config.left.constant))
		else:
			return
		var member_rect = left_member_icon.get_global_rect()
		supply_label.move_to_supply_rect(member_rect)

func show_right_popup():
	var config = conditional_expression.configuration
	if(config.has("right")):
		if(config.right.has("variable")):
			var supply = supply_collection.get_supply(config.right.variable)
			var localization = supply.get_translation()
			supply_label.show_name(localization.name)
		elif(config.right.has("constant")):
			supply_label.show_name(str(config.right.constant))
		else:
			return
		var member_rect = right_member_icon.get_global_rect()
		supply_label.move_to_supply_rect(member_rect)

func hide_label():
	supply_label.hide_name()

func set_popup_pos(button : Button):
	var popup_width = constant_config_popup.size.x
	var button_width = button.size.x
	var x_adjust = button_width / 2 - popup_width / 2
	var offset = Vector2(x_adjust, -56)
	constant_config_popup.position = button.global_position + offset
