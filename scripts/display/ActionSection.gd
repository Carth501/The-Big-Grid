class_name Action_Section extends Control

@export var section_label : Label
@export var editor_container : HFlowContainer

func set_label(section_name : String):
	section_label.text = section_name

func add_machine_editor(new_editor : Action_Machine_Editor):
	editor_container.add_child(new_editor)
	recalculate_minimum_size()

func recalculate_minimum_size():
	var vertical = editor_container.size.y + section_label.size.y
	custom_minimum_size.y = vertical
