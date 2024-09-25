class_name Hotkey_Popup extends PanelContainer

@export var label : Label
@export var margin_container : MarginContainer
var opening := false
var closing := false
var is_open := false
@export var scale_magnitude := 6.5
@export var open_vector := Vector2.ONE
@export var closed_vector := Vector2(1,0)

func open(keystroke: String):
	label.text = keystroke
	scale = closed_vector
	opening = true
	closing = false
	is_open = true
	size = get_minimum_size()

func change_text(keystroke: String):
	if(!is_open):
		open(keystroke)
	else:
		label.text = keystroke
		size = get_minimum_size()

func close():
	closing = true
	opening = false
	is_open = false

func _process(delta: float) -> void:
	if(opening):
		scale = lerp(scale, open_vector, delta*scale_magnitude)
		if(scale.is_equal_approx(open_vector)):
			opening = false
	elif(closing):
		scale = lerp(scale, closed_vector, delta*scale_magnitude)
		if(scale.is_equal_approx(closed_vector)):
			closing = false
