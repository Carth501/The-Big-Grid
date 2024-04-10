class_name resource_popup extends Control

@export var resources : resource_pile
var active_resource : resource
@export var close_button : Button
@export var name_label : LineEdit
@export var name_edit_button : Button
@export var upgrade_max_button : Button
@export var upgrade_max_cost_label : Label

func set_resource(new_resource : resource):
	active_resource = new_resource
	name_label.text = active_resource.name_label.text
	upgrade_max_cost_label.text = str("+", active_resource.max_increment)
	set_position(active_resource.position + Vector2(80,80))

func close():
	visible = false
