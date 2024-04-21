class_name Machine extends Node

var action_id : String
var supply_collection : Supply_Collection
var timer : Timer

func set_id(id : String):
	action_id = id

func set_supply_collection(new_collection : Supply_Collection):
	supply_collection = new_collection

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(apply_changes)
	timer.wait_time = 1
	timer.start()

func apply_changes():
	supply_collection.apply_changes(action_id)
