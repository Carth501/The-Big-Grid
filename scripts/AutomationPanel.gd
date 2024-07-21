extends ColorRect

@onready var machine_editor_prefab := preload("res://scenes/display/ActionMachineEditor.tscn")
@export var machine_container : HFlowContainer
@export var machine_factory : Machine_Factory

func _ready() -> void:
	var machine_registry = machine_factory.machine_registry
	for machine_id in machine_registry:
		add_machine_editor(machine_registry[machine_id])

func add_machine_editor(new_machine : Machine):
	var new_machine_editor = machine_editor_prefab.instantiate()
	new_machine_editor.set_machine(new_machine)
	machine_container.add_child(new_machine_editor)
