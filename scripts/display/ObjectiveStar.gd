class_name Objective_Star extends TextureRect

@export var condition_panel : Control
@onready var key_prefab = preload("res://scenes/display/ObjectiveKey.tscn")

func set_objective_conditions(obj_def : Dictionary):
	var height = obj_def.size() * 42 + 2
	condition_panel.size = Vector2(68, height)
	var i = 0
	if(obj_def.has("less_than")):
		var new_key_display = key_prefab.instantiate()
		var vert = i * 40 + 4
		new_key_display.position = Vector2(2, vert)
		condition_panel.add_child(new_key_display)
		new_key_display.set_comparator("<")
		if(obj_def["less_than"].has("supply")):
			var id = obj_def["less_than"]["supply"]
			new_key_display.set_objective_supply(id)
		else:
			var value = obj_def["less_than"]["const"]
			new_key_display.set_objective_constant(value)
	if(obj_def.has("equal_to")):
		var new_key_display = key_prefab.instantiate()
		var vert = i * 40 + 4
		new_key_display.position = Vector2(2, vert)
		condition_panel.add_child(new_key_display)
		new_key_display.set_comparator("=")
		if(obj_def["equal_to"].has("supply")):
			var id = obj_def["equal_to"]["supply"]
			new_key_display.set_objective_supply(id)
		else:
			var value = obj_def["equal_to"]["const"]
			new_key_display.set_objective_constant(value)
	if(obj_def.has("greater_than")):
		var new_key_display = key_prefab.instantiate()
		var vert = i * 40 + 4
		new_key_display.position = Vector2(2, vert)
		condition_panel.add_child(new_key_display)
		new_key_display.set_comparator(">")
		if(obj_def["greater_than"].has("supply")):
			var id = obj_def["greater_than"]["supply"]
			new_key_display.set_objective_supply(id)
		else:
			var value = obj_def["greater_than"]["const"]
			new_key_display.set_objective_constant(value)

func open_objective_panel():
	condition_panel.visible = true

func close_objective_panel():
	condition_panel.visible = false
