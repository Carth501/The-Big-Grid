class_name Logic_Directory extends Node

signal new_object(String)
var directory : Dictionary

func index_object(object_type : String, object):
	if(directory.has(object_type)):
		push_warning("object_type is being overwritten. Was this intended?")
	directory[object_type] = object

func get_object(object_type : String):
	if(directory.has(object_type)):
		return directory[object_type]
	else:
		push_warning(str("logic_directory does not have ", object_type))
