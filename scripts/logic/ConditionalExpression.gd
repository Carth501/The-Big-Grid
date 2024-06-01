class_name Conditional_Expression extends Node

enum Comparators {
	GREATER,
	EQUAL,
	LESS
}

signal update_value(float)
signal config_change
signal delete_this(Conditional_Expression)

var configuration : Dictionary
var supply_collection : Supply_Collection
var edit_left := false
var edit_right := false
var comparator := Comparators.EQUAL
var evaluation := true

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
		var left = configuration["left"]
		if(left.has("constant")):
			return configuration.constant
		elif(left.has("variable")):
			var supply = supply_collection.get_supply(left.variable)
			return supply.value
	return -1

func get_right_value() -> float:
	if(configuration.has("right")):
		var right = configuration["right"]
		if(right.has("constant")):
			return configuration.constant
		elif(right.has("variable")):
			var supply = supply_collection.get_supply(right.variable)
			return supply.value
	return -1

func set_left_constant(value : float):
	disconnect_old_left_variable()
	configuration["left"] = {"constant": value}
	config_change.emit()
	evaluate()
	disconnect_left_selection()

func set_left_variable(id : String):
	disconnect_old_left_variable()
	configuration["left"] = {"variable": id}
	config_change.emit()
	evaluate()
	var supply = supply_collection.get_supply(id)
	supply.update_value.connect(handle_variable_update)
	disconnect_left_selection()

func set_right_constant(value : float):
	disconnect_old_right_variable()
	configuration["right"] = {"constant": value}
	config_change.emit()
	evaluate()
	disconnect_right_selection()

func set_right_variable(id : String):
	disconnect_old_right_variable()
	configuration["right"] = {"variable": id}
	config_change.emit()
	evaluate()
	var supply = supply_collection.get_supply(id)
	supply.update_value.connect(handle_variable_update)
	disconnect_right_selection()

func disconnect_old_left_variable():
	if(configuration.has("left")):
		if(configuration["left"].has("variable")):
			var id = configuration["left"].variable
			var supply = supply_collection.get_supply(id)
			supply.update_value.disconnect(handle_variable_update)

func disconnect_old_right_variable():
	if(configuration.has("right")):
		if(configuration["right"].has("variable")):
			var id = configuration["right"].variable
			var supply = supply_collection.get_supply(id)
			supply.update_value.disconnect(handle_variable_update)

func handle_variable_update(_value):
	evaluate()

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
	supply_collection.constant_selection.disconnect(set_left_constant)
	supply_collection.variable_selection.disconnect(set_left_variable)

func disconnect_right_selection():
	edit_right = false
	supply_collection.constant_selection.disconnect(set_right_constant)
	supply_collection.variable_selection.disconnect(set_right_variable)

func reset_editing():
	if(edit_left):
		disconnect_left_selection()
	if(edit_right):
		disconnect_right_selection()

func set_comparator(new_comparator : Comparators):
	comparator = new_comparator

func evaluate():
	var left = get_left_value()
	var right = get_right_value()

	if(left == -1 || right == -1):
		evaluation = false
		return

	if(comparator == Comparators.GREATER):
		evaluation = left > right
	elif(comparator == Comparators.EQUAL):
		evaluation = left == right
	elif(comparator == Comparators.LESS):
		evaluation = left < right
	else:
		push_warning(str("comparator is something weird: ", comparator))

func delete():
	delete_this.emit(self)
	queue_free()

func load_config(config : Dictionary):
	configuration = config
	config_change.emit()
