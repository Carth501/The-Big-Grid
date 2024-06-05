class_name Supply extends Node

signal update_value(value : float)
signal new_delta(value : float)
signal update_max(v_max : float)
signal update_active
signal open_menu(Supply)
signal select(String)
signal set_obj(Array)
signal unset_obj()

var id := ""
var value := 0.0
var v_max := 20.0
var max_increment := 10.0
var max_upgrade_count := 0
var degrade := 0.0
var max_increase_base_cost : Dictionary
var max_upgrade_available := true
var active := false
var supply_collection : Supply_Collection
var filter_foreman : Filter_Foreman
var supply_icon_path : String
var upgrade_hover := true
var upgrade_focus := false

func set_id(new_id : String):
	id = new_id
	var definition = SupplyDefsSingle.data[id]
	if(definition.has("default_value")):
		value = definition.default_value
	if(definition.has("default_max")):
		v_max = definition.default_max
	if(definition.has("max_increase_increment")):
		max_increment = definition.max_increase_increment
	else:
		max_upgrade_available = false
	if(definition.has("max_increase_base_cost")):
		max_increase_base_cost = definition.max_increase_base_cost
	else:
		max_upgrade_available = false
	if(definition.has("icon_path")):
		supply_icon_path = definition.icon_path
	if(definition.has("degrade")):
		degrade = definition.degrade
		var timer = Timer.new()
		timer.wait_time = 1.0
		timer.timeout.connect(process_degrade)
		add_child(timer)
		timer.start()

func set_collection(collection : Supply_Collection):
	supply_collection = collection

func set_filter_foreman(foreman : Filter_Foreman):
	filter_foreman = foreman

func test_deltas(deltas: Array) -> bool:
	var dummy_value = value
	for delta in deltas:
		dummy_value += delta
		if(dummy_value < 0 || dummy_value > v_max):
			return false
	return true

func apply_change(deltas: Array):
	for delta in deltas:
		value += delta
		new_delta.emit(delta)
	update_value.emit(value)

func activate():
	update_active.emit()
	active = true

func trigger_select():
	select.emit(id)

func open():
	open_menu.emit(self)

func attempt_upgrade_max():
	var success = supply_collection.attempt_purchase(calculate_upgrade_cost())
	if(success):
		max_upgrade_count += 1
		v_max += max_increment
		update_max.emit(v_max)
		if(upgrade_hover):
			filter_foreman.set_primary_filter(calculate_upgrade_cost())
		if(upgrade_focus):
			filter_foreman.set_secondary_filter(calculate_upgrade_cost())

func calculate_upgrade_cost() -> Dictionary:
	if(max_increase_base_cost == null || max_increase_base_cost == {}):
		return {}
	var count := max_upgrade_count + 1
	var cost = max_increase_base_cost.duplicate(true)
	for supply in cost:
		var supply_deltas = cost[supply].deltas
		for index in range(supply_deltas.size()):
			supply_deltas[index] *= count
	return cost

func set_upgrade_hover():
	filter_foreman.set_primary_filter(calculate_upgrade_cost())
	upgrade_hover = true

func unset_upgrade_hover():
	filter_foreman.clear_primary_filter()
	upgrade_hover = false

func set_upgrade_focus():
	filter_foreman.set_secondary_filter(calculate_upgrade_cost())
	upgrade_focus = true

func unset_upgrade_focus():
	filter_foreman.clear_secondary_filter()
	upgrade_focus = false

func set_name_override(new_name : String):
	SupplyTranslatorSingle.set_name_override(id, new_name)

func get_translation() -> String:
	return SupplyTranslatorSingle.data[id]

func load_values(values : Dictionary):
	value = values["value"]
	update_value.emit(value)
	v_max = values["v_max"]
	update_max.emit(v_max)
	max_upgrade_count = values["max_upgrade_count"]
	update_value.emit(value)
	if(values["active"]):
		activate()

func set_objective(obj_def: Array):
	set_obj.emit(obj_def)

func unset_objective():
	unset_obj.emit()

func process_degrade():
	var new_value = value * degrade
	value = new_value
