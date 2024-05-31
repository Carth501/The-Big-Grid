class_name Save_Handler extends Node

var active_save : Dictionary
var save_file_names : Array[String] = []
var save_folder = "user://saves/"

func _ready():
	var user = DirAccess.open("user://")
	if(!user.dir_exists(save_folder)):
		user.make_dir("saves")
	var dir = DirAccess.open(save_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				if(check_file_is_save(file_name)):
					save_file_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func check_file_is_save(save_file_name : String) -> bool:
	var path = save_folder + save_file_name
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return true
	return false

func get_save_names() -> Array[String]:
	return save_file_names

func load_save(save_file_name : String):
	var path = save_folder + save_file_name
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			active_save = parsedResult
		else:
			push_error("error reading the translation file")
	else:
		push_error("translation file does not exist")

func write_save(data : Dictionary):
	active_save = data
	var path = save_folder + active_save.file_name
	var data_file = FileAccess.open(path, FileAccess.WRITE)
	data_file.store_var(active_save)
	data_file.close()
