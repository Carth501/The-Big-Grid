class_name resource_pile extends Control

var resources := {}
@export var resource_grid : GridContainer
@export var _resource_popup : resource_popup
var resource_bins := {}
@onready var resource_pack = preload("res://scenes/Resource_Stack.tscn")

func _ready():
	add_resource("A")
	add_resource("B")

func get_resource(id: String):
	if(!resources.has(id)):
		return null
	return resources[id]

func add_resource(id: String):
	var new_resource : resource = resource_pack.instantiate()
	resource_grid.add_child(new_resource)
	resources[id] = new_resource
	new_resource.set_id(id)
	new_resource.set_resource_popup(_resource_popup)

func apply_changes(changes: Variant):
	var valid = true
	for change in changes:
		var target = get_resource(change.id)
		if(target == null && deltas_remain_positive(change.deltas)):
			add_resource(change.id)
			target = get_resource(change.id)
		if(target == null || !target.test_deltas(change.deltas)):
			valid = false
	if(!valid):
		return
	for change in changes:
		var target = get_resource(change.id)
		target.apply_deltas(change.deltas)

func attempt_purchase(costs : Dictionary) -> bool:
	var cost_resources = costs.keys()
	for r in cost_resources:
		var target = get_resource(r)
		if(target == null || !target.test_deltas([costs[r]])):
			return false
	for r in cost_resources:
		var target = get_resource(r)
		target.apply_deltas([costs[r]])
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
