class_name Hotkey_Controller extends Node

signal update_to(id)

@export var action_manager: Action_Manager
var shift := false
var ctrl := false
var alt := false
var hotkey_map := {}

func _ready() -> void:
	Logic_Directory_Single.index_object("Hotkey_Controller", self)

func _input(event):
	var operation_string = ""
	if(shift):
		operation_string += "shift+"
	if(alt):
		operation_string += "alt+"
	if event.is_action_pressed("shift"):
		shift = true
		return
	elif event.is_action_released("shift"):
		shift = false
		return
	elif event.is_action_pressed("ctrl"):
		ctrl = true
		return
	elif event.is_action_released("ctrl"):
		ctrl = false
		return
	elif event.is_action_pressed("alt"):
		alt = true
		return
	elif event.is_action_released("alt"):
		alt = false
		return
	elif event.is_action_pressed("a"):
		operation_string += "A"
	elif event.is_action_pressed("b"):
		operation_string += "B"
	elif event.is_action_pressed("c"):
		operation_string += "C"
	elif event.is_action_pressed("d"):
		operation_string += "D"
	elif event.is_action_pressed("e"):
		operation_string += "E"
	elif event.is_action_pressed("f"):
		operation_string += "F"
	elif event.is_action_pressed("g"):
		operation_string += "G"
	elif event.is_action_pressed("h"):
		operation_string += "H"
	elif event.is_action_pressed("i"):
		operation_string += "I"
	elif event.is_action_pressed("j"):
		operation_string += "J"
	elif event.is_action_pressed("k"):
		operation_string += "K"
	elif event.is_action_pressed("l"):
		operation_string += "J"
	elif event.is_action_pressed("m"):
		operation_string += "M"
	elif event.is_action_pressed("n"):
		operation_string += "N"
	elif event.is_action_pressed("o"):
		operation_string += "O"
	elif event.is_action_pressed("p"):
		operation_string += "P"
	elif event.is_action_pressed("q"):
		operation_string += "Q"
	elif event.is_action_pressed("r"):
		operation_string += "R"
	elif event.is_action_pressed("s"):
		operation_string += "S"
	elif event.is_action_pressed("t"):
		operation_string += "T"
	elif event.is_action_pressed("u"):
		operation_string += "U"
	elif event.is_action_pressed("v"):
		operation_string += "V"
	elif event.is_action_pressed("w"):
		operation_string += "W"
	elif event.is_action_pressed("x"):
		operation_string += "X"
	elif event.is_action_pressed("y"):
		operation_string += "Y"
	elif event.is_action_pressed("z"):
		operation_string += "Z"
	elif event.is_action_pressed("1"):
		operation_string += "1"
	elif event.is_action_pressed("2"):
		operation_string += "2"
	elif event.is_action_pressed("3"):
		operation_string += "3"
	elif event.is_action_pressed("4"):
		operation_string += "4"
	elif event.is_action_pressed("5"):
		operation_string += "5"
	elif event.is_action_pressed("6"):
		operation_string += "6"
	elif event.is_action_pressed("7"):
		operation_string += "7"
	elif event.is_action_pressed("8"):
		operation_string += "8"
	elif event.is_action_pressed("9"):
		operation_string += "9"
	elif event.is_action_pressed("0"):
		operation_string += "0"
	else:
		return
	if(ctrl):
		reassign(operation_string)
	else:
		trigger(operation_string)

func reassign(operation_string):
	var id = action_manager.designated_action_id
	if(id != ""):
		for key in hotkey_map:
			if(hotkey_map[key] == id):
				hotkey_map.erase(key)
		hotkey_map[operation_string] = id
		update_to.emit(id)

func trigger(operation_string):
	if(hotkey_map.has(operation_string)):
		var action_id = hotkey_map[operation_string]
		action_manager.full_action_list[action_id].apply()

func map_has_value(action_id : String):
	for key in hotkey_map:
		if(hotkey_map[key] == action_id):
			return true
	return false

func get_key(action_id : String):
	for key in hotkey_map:
		if(hotkey_map[key] == action_id):
			return key
