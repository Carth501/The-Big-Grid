class_name Copy_Handler extends Node

var memory := {}

func _ready():
	Logic_Directory_Single.index_object("Copy_Handler", self)

func copy_machine(target_machine : Machine):
	var settings = {"type": "machine"}
	settings["active"] = target_machine.get_running()
	settings["interval"] = target_machine.get_interval()
	settings["conditionals"] = []
	for conditional in target_machine.conditionals:
		settings["conditionals"].append({
			"configuration": conditional.configuration,
			"comparator": conditional.comparator
			})
	memory = settings

func paste_machine(target_machine : Machine):
	if(memory.has("type") && memory.type == "machine"):
		target_machine.load_conditions(memory["conditionals"])
		target_machine.set_running(memory["active"])
		target_machine.set_interval(memory["interval"])

func copy_conditional(conditional_expression : Conditional_Expression):
	var settings = {"type": "conditional"}
	settings["configuration"] = conditional_expression.configuration
	memory = settings

func get_memory() -> Dictionary:
	return memory
