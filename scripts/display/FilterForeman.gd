class_name Filter_Foreman extends Node

signal update_filter(filter : Dictionary)

var primary_filter : Dictionary
var secondary_filter : Dictionary

func set_primary_filter(filter : Dictionary):
	primary_filter = filter
	choose_filter()
	
func set_secondary_filter(filter : Dictionary):
	secondary_filter = filter
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
