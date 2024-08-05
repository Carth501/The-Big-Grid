class_name Action_Section extends Control

@export var section_label : Button
@export var editor_container : HFlowContainer
var expanded := false

func set_label(section_name : String):
	section_label.text = section_name

func add_machine_editor(new_editor : Action_Machine_Editor):
	editor_container.add_child(new_editor)

func recalculate_minimum_size():
	if(expanded):
		var vertical = editor_container.size.y + section_label.size.y + 8
		custom_minimum_size.y = vertical
	else:
		custom_minimum_size.y = section_label.size.y

func _on_h_flow_container_child_entered_tree(_node: Node) -> void:
	recalculate_minimum_size()

func toggle_expand():
	expand(!expanded)

func expand(setting : bool):
	expanded = setting
	editor_container.visible = setting
	recalculate_minimum_size()
