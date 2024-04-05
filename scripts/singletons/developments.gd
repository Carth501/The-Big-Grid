extends Node

var data : Array
@export var data_path = "res://data/developments.json"

func _ready():
	data = load_json_file(data_path)

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Array:
			return parsedResult
		else:
			push_error("error reading the translation file")
	else:
		push_error("translation file does not exist")
