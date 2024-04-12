class_name resource_pile extends Control

var resources := {}
@export var resource_grid : GridContainer
@export var _resource_popup : resource_popup
@onready var resource_pack = preload("res://scenes/Resource_Stack.tscn")
var primary_filter_list : Dictionary = {}
var secondary_filter_list : Dictionary = {}

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
		var target = get_resource(change)
		if(target == null && deltas_remain_positive(changes[change].deltas)):
			add_resource(change)
			target = get_resource(change)
		if(target == null || !target.test_deltas(changes[change].deltas)):
			valid = false
	if(!valid):
		return
	for change in changes:
		var target = get_resource(change)
		target.apply_deltas(changes[change].deltas)

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

func set_primary_filter(change : Dictionary):
	primary_filter_list = change
	handle_visibility()

func set_secondary_filter(change : Dictionary):
	secondary_filter_list = change
	handle_visibility()

func clear_primary_filter():
	primary_filter_list = {}
	handle_visibility()

func clear_secondary_filter():
	secondary_filter_list = {}
	handle_visibility()

func handle_visibility():
	if(primary_filter_list.size() > 0):
		display_buckets(primary_filter_list)
		set_deltas(primary_filter_list)
	elif(secondary_filter_list.size() > 0):
		display_buckets(secondary_filter_list)
		set_deltas(secondary_filter_list)
	else:
		for resource_bucket in resources:
			resources[resource_bucket].visible = true
			resources[resource_bucket].clear_delta()

func display_buckets(list : Dictionary):
	for resource_bucket in resources:
		if(resources.has(resource_bucket)):
			if(list.has(resource_bucket)):
				resources[resource_bucket].visible = true
			else:
				resources[resource_bucket].visible = false

func set_deltas(resource_change : Dictionary):
	for resource_bucket in resources:
		if(resource_change.has(resource_bucket)):
			var deltas = resource_change[resource_bucket].deltas
			resources[resource_bucket].set_delta(deltas)
		else:
			resources[resource_bucket].set_delta([])

