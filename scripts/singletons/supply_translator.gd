extends Node

signal new_override(id : String)

var data : Dictionary
var overrides : Dictionary = {}
@export var en_file_json = "res://data/supply_names_en.json"

func _ready():
	data = load_json_file(en_file_json)

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

func get_supply_name(id : String) -> String:
	if(overrides.has(id) && overrides[id] != ""):
		return overrides[id]
	else:
		return data[id]

func get_supply_names(ids : Array) -> Array:
	var list : Array[String] = []
	for id in ids:
		if(overrides.has(id) && overrides[id] != ""):
			list.append(overrides[id])
		else:
			list.append(data[id])
	return list

func set_name_override(id, new_name):
	print(str("set_name_override ", id, " ", new_name))
	overrides[id] = new_name
	new_override.emit(id)
