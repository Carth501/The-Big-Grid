extends Node

var translation_data : Dictionary
@export var en_file_json = "res://data/resource_names_en.json"

func _ready():
	translation_data = load_json_file(en_file_json)

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			push_error("error reading the translation file")
	else:
		push_error("translation file does not exist")
