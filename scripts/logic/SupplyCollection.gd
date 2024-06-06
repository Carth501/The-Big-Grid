class_name Supply_Collection extends Node

signal constant_selection(value : float)
signal variable_selection(id : String)
signal new_supply(id : String)
signal open_supply(supply : Supply)
var supplies := {}
var selection_mode := false
@export var filter_foreman : Filter_Foreman

func _ready():
	Logic_Directory_Single.index_object("Supply_Collection", self)

func get_supply(id: String) -> Supply:
	if(!supplies.has(id)):
		push_warning(str(id, " requested, but it does not exist."))
		return null
	return supplies[id]

func get_or_create_supply(id : String) -> Supply:
	if(!supplies.has(id)):
		add_supply(id)
	return supplies[id]

func add_supply(id: String):
	if(!supplies.has(id)):
		var supply := Supply.new()
		add_child(supply)
		supplies[id] = supply
		supply.select.connect(select_supply)
		supply.set_id(id)
		supply.set_collection(self)
		supply.set_filter_foreman(filter_foreman)
		new_supply.emit(id)
		supply.open_menu.connect(open_supply_menu)

func apply_changes(changes : Dictionary):
	if(!test_action_changes(changes)):
		return
	for change in changes:
		var target = get_supply(change)
		target.apply_change(changes[change].deltas)

func attempt_purchase(changes : Dictionary) -> bool:
	for r in changes:
		var target = get_supply(r)
		if(target == null || !target.test_deltas(changes[r].deltas)):
			return false
	for r in changes:
		var target = get_supply(r)
		target.apply_change(changes[r].deltas)
	return true

func calculate_net_delta(deltas : Array) -> int:
	var net := 0
	for delta in deltas:
		net += delta
	return net

func deltas_remain_positive(deltas : Array) -> bool:
	var net := 0
	for delta in deltas:
		net += delta
		if(net <= 0):
			return false
	return true

func test_action_changes(changes : Dictionary):
	for supply_id in changes:
		var target = get_supply(supply_id)
		if(target == null):
			add_supply(supply_id)
			target = get_supply(supply_id)
		if(!target.test_deltas(changes[supply_id].deltas)):
			return false
	return true

func open_supply_menu(supply : Supply):
	open_supply.emit(supply)

func request_member_selection():
	selection_mode = true

func select_supply(id : String):
	if(selection_mode):
		variable_selection.emit(id)
		selection_mode = false

func get_all_supply_ids() -> Array[String]:
	var supply_ids : Array[String] = []
	for id in supplies:
		supply_ids.append(id)
	return supply_ids
