class_name Machine extends Node

var action_id : String
var action_changes : Dictionary
var resources : resource_pile
var timer : Timer

func set_id(id : String):
	action_id = id

func set_changes(changes : Dictionary):
	action_changes = changes

func set_resource_pile(pile : resource_pile):
	resources = pile

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(apply_changes)
	timer.wait_time = 1
	timer.start()

func apply_changes():
	resources.apply_changes(action_changes)
