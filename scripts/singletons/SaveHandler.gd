class_name Save_Handler extends Node

var active_save : Dictionary
var save_file_metadata : Array = []
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
				var save_file = get_save(file_name)
				if(save_file != null):
					save_file_metadata.append({
						"file_name": file_name,
						"save_time": save_file.save_time
					})
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path.")

func get_save_metadata() -> Array:
	return save_file_metadata

func prepare_save(save_file_name : String):
	active_save = get_save(save_file_name)

func clear_save():
	active_save = {}

func prepare_recent_save():
	if(save_file_metadata.size() > 0):
		var recent_save
		for save in save_file_metadata:
			var this_time = save["save_time"]
			if(recent_save == null || recent_save["save_time"] < this_time):
				recent_save = save
		prepare_save(recent_save["file_name"])

func get_save(save_file_name : String):
	var path = save_folder + save_file_name
	
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ)
		var parsedResult = dataFile.get_var()
		if parsedResult is Dictionary:
			return parsedResult
		else:
			push_error("error reading the save file")
	else:
		push_error("file does not exist")

func write_save(data : Dictionary):
	active_save = data
	var file_name = active_save["file_name"]
	if(file_name == null):
		file_name = "save"
	var path = save_folder + file_name
	var data_file = FileAccess.open(path, FileAccess.WRITE)
	if(data_file != null && data_file.get_error() == OK):
		data_file.store_var(data)
		data_file.close()
	else:
		push_error(str("data file not opened. attempted path = ", path))
