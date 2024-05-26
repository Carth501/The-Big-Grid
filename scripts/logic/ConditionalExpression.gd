class_name Conditional_Expression extends Node

signal update_value(float)
signal config_change

var configuration : Dictionary
var supply_collection : Supply_Collection
var edit_left := false
var edit_right := false

func _ready():
	if(Logic_Directory_Single.directory.has("Supply_Collection")):
		supply_collection = Logic_Directory_Single.directory["Supply_Collection"]
	else:
		Logic_Directory_Single.new_object.connect(set_collection)

func set_collection(id : String):
	if(id == "Supply_Collection"):
		supply_collection = Logic_Directory_Single.directory["Supply_Collection"]

func get_left_value() -> float:
	if(configuration.has("left")):
		if(configuration.has("constant")):
			return configuration.constant
		elif(configuration.has("variable")):
			var supply = supply_collection.get_supply(configuration.variable)
			return supply.value
	return -1

func get_right_value() -> float:
	if(configuration.has("right")):
		if(configuration.has("constant")):
			return configuration.constant
		elif(configuration.has("variable")):
			var supply = supply_collection.get_supply(configuration.variable)
			return supply.value
	return -1

func set_left_constant(value : float):
	configuration["left"] = {"constant": value}
	config_change.emit()
	disconnect_left_selection()

func set_left_variable(id : String):
	configuration["left"] = {"variable": id}
	config_change.emit()
	disconnect_left_selection()

func set_right_constant(value : float):
	configuration["right"] = {"constant": value}
	config_change.emit()
	disconnect_right_selection()

func set_right_variable(id : String):
	configuration["right"] = {"variable": id}
	config_change.emit()
	disconnect_right_selection()

func start_left_selection():
	reset_editing()
	edit_left = true
	supply_collection.constant_selection.connect(set_left_constant)
	supply_collection.variable_selection.connect(set_left_variable)
	supply_collection.request_member_selection()

func start_right_selection():
	reset_editing()
	edit_right = true
	supply_collection.constant_selection.connect(set_right_constant)
	supply_collection.variable_selection.connect(set_right_variable)
	supply_collection.request_member_selection()

func disconnect_left_selection():
	edit_left = false
	print("attempting disconnect_left_selection")
	supply_collection.constant_selection.disconnect(set_left_constant)
	supply_collection.variable_selection.disconnect(set_left_variable)

func disconnect_right_selection():
	edit_right = false
	print("attempting disconnect_right_selection")
	supply_collection.constant_selection.disconnect(set_right_constant)
	supply_collection.variable_selection.disconnect(set_right_variable)

func reset_editing():
	if(edit_left):
		disconnect_left_selection()
	if(edit_right):
		disconnect_right_selection()
