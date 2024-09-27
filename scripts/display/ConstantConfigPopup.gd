class_name Constant_Config_Popup extends Panel

signal new_constant(value)

@export var slider : HSlider
@export var spin_box : SpinBox
@export var disabled_curtain : Panel
var value : int = 0
var opening := false
var closing := false
var is_open := false
@export var scale_magnitude := 6.5
@export var open_vector := Vector2.ONE
@export var closed_vector := Vector2(1,0)

func open(value : int, max_value : int, disabled : bool):
	scale = closed_vector
	opening = true
	closing = false
	is_open = true
	size = get_minimum_size()
	show()
	slider.set_value_no_signal(value)
	slider.max_value = max_value
	slider.min_value = -max_value
	spin_box.set_value_no_signal(value)
	spin_box.max_value = max_value
	spin_box.min_value = -max_value
	disabled_curtain.visible = disabled

func close():
	closing = true
	opening = false
	is_open = false

func spin_box_set_value(new_value : float):
	var value_int = roundi(new_value)
	value = value_int
	slider.set_value_no_signal(value)

func slider_set_value(new_value : float):
	var value_int = roundi(new_value)
	value = value_int
	spin_box.set_value_no_signal(value)

func set_constant():
	new_constant.emit(value)

func _process(delta: float) -> void:
	if(opening):
		scale = lerp(scale, open_vector, delta*scale_magnitude)
		if(scale.is_equal_approx(open_vector)):
			opening = false
	elif(closing):
		scale = lerp(scale, closed_vector, delta*scale_magnitude)
		if(scale.is_equal_approx(closed_vector)):
			closing = false
			hide()
