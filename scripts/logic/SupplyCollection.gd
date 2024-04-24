class_name Supply_Collection extends Node

signal new_supply(id : String)
var supplies := {}

func get_supply(id: String) -> Supply:
	if(!supplies.has(id)):
		return null
	return supplies[id]

func get_or_create_supply(id : String) -> Supply:
	if(!supplies.has(id)):
		add_supply(id)
	return supplies[id]

func add_supply(id: String):
	var supply := Supply.new()
	add_child(supply)
	supplies[id] = supply
	supply.set_id(id)
	new_supply.emit(id)

func apply_changes(id: String):
	if(!test_action_changes(id)):
		return
	var changes = ActionsSingle.data[id].changes
	for change in changes:
		var target = get_supply(change)
		target.apply_change(changes[change].deltas)

func attempt_purchase(costs : Dictionary) -> bool:
	for r in costs:
		var target = get_supply(r)
		if(target == null || !target.test_deltas(costs[r].deltas)):
			return false
	for r in costs:
		var target = get_supply(r)
		target.apply_change(costs[r].deltas)
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

func test_action_changes(id: String):
	var changes = ActionsSingle.data[id].changes
	for supply_id in changes:
		var target = get_supply(supply_id)
		if(target == null):
			add_supply(supply_id)
			target = get_supply(supply_id)
		if(!target.test_deltas(changes[supply_id].deltas)):
			return false
	return true
