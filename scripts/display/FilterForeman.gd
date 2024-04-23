class_name Filter_Foreman extends Node

signal update_filter(filter : Dictionary)

var primary_filter : Dictionary
var secondary_filter : Dictionary

func set_action_primary_filter(id : String):
	primary_filter = action_dereference(id)
	choose_filter()
	
func set_action_secondary_filter(id : String):
	secondary_filter = action_dereference(id)
	choose_filter()

func set_dev_primary_filter(id : String):
	primary_filter = dev_dereference(id)
	choose_filter()
	
func set_dev_secondary_filter(id : String):
	secondary_filter = dev_dereference(id)
	choose_filter()

func clear_primary_filter():
	primary_filter = {}
	choose_filter()

func clear_secondary_filter():
	secondary_filter = {}
	choose_filter()

func choose_filter():
	if(primary_filter != {}):
		apply_filter(primary_filter)
	elif(secondary_filter != {}):
		apply_filter(secondary_filter)
	else:
		apply_filter({})

func apply_filter(filter : Dictionary):
	update_filter.emit(filter)

func action_dereference(id : String) -> Dictionary:
	return ActionsSingle.data[id].changes

func dev_dereference(id : String) -> Dictionary:
	return DevelopmentsSingle.data[id].cost
