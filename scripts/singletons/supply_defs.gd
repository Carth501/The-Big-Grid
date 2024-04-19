extends Node

var data : Dictionary
@export var data_path = "res://data/supply_definitions.json"

func _ready():
	data = load_json_file(data_path)

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			push_error("error reading the actions file")
	else:
		push_error("actions file does not exist")
