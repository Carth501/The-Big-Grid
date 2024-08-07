extends ColorRect

signal recalculate_all
@onready var machine_editor_prefab := preload("res://scenes/display/ActionMachineEditor.tscn")
@onready var action_section_prefab:= preload("res://scenes/display/ActionSection.tscn")
@export var action_section_container : Control
@export var machine_factory : Machine_Factory
@export var machine_editors : Dictionary
@export var action_sections : Dictionary

func add_machine_editor(new_machine : Machine):
	var action_id = new_machine.action.id
	var new_machine_editor = machine_editor_prefab.instantiate()
	new_machine_editor.set_machine(new_machine)
	if(!action_sections.has(action_id)):
		var new_action_section = action_section_prefab.instantiate()
		action_section_container.add_child(new_action_section)
		var action_name = ActionTranslatorSingle.data[action_id].name
		new_action_section.set_label(action_name)
		action_sections[action_id] = new_action_section
		recalculate_all.connect(new_action_section.recalculate_minimum_size)
	action_sections[action_id].add_machine_editor(new_machine_editor)
	recalculate_all.emit()

func _on_visibility_changed() -> void:
	recalculate_all.emit()

func _on_scroll_container_resized() -> void:
	recalculate_all.emit()
