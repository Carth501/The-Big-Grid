class_name Supply_Change_Feedback extends Control

var positive_floaters : Array
var negative_floaters : Array
@onready var positive_pack = preload("res://scenes/display/feedback/PositiveFeedback.tscn")
@onready var negative_pack = preload("res://scenes/display/feedback/NegativeFeedback.tscn")

func new_delta(value : float):
	if(value > 0):
		var new_positive = positive_pack.instantiate()
		new_positive.text = str("%+.1f" % value)
		add_child(new_positive)
		positive_floaters.append(new_positive)
	elif(value < 0):
		var new_negative = negative_pack.instantiate()
		new_negative.text = str("%.1f" % value)
		add_child(new_negative)
		negative_floaters.append(new_negative)

