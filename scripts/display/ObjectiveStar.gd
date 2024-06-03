class_name Objective_Star extends TextureRect

@export var condition_panel : Control
@onready var key_prefab = preload("res://scenes/display/ObjectiveKey.tscn")

func set_objective_conditions(obj_def : Array):
	var height = obj_def.size() * 42 + 2
	condition_panel.size = Vector2(68, height)
	var i = 0
	for criteria in obj_def:
		var new_key_display = key_prefab.instantiate()
		var vert = i * 40 + 4
		new_key_display.position = Vector2(2, vert)
		condition_panel.add_child(new_key_display)
		if(criteria.has("less_than")):
			new_key_display.set_comparator("<")
			if(criteria["less_than"].has("supply")):
				var id = criteria["less_than"]["supply"]
				new_key_display.set_objective_supply(id)
			else:
				var value = criteria["less_than"]["const"]
				new_key_display.set_objective_constant(value)
		elif(criteria.has("equal_to")):
			new_key_display.set_comparator("=")
			if(criteria["equal_to"].has("supply")):
				var id = criteria["equal_to"]["supply"]
				new_key_display.set_objective_supply(id)
			else:
				var value = criteria["equal_to"]["const"]
				new_key_display.set_objective_constant(value)
		elif(criteria.has("greater_than")):
			new_key_display.set_comparator(">")
			if(criteria["greater_than"].has("supply")):
				var id = criteria["greater_than"]["supply"]
				new_key_display.set_objective_supply(id)
			else:
				var value = criteria["greater_than"]["const"]
				new_key_display.set_objective_constant(value)
		i += 1

func open_objective_panel():
	condition_panel.visible = true

func close_objective_panel():
	condition_panel.visible = false
