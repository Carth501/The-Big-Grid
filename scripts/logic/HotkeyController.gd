class_name Hotkey_Controller extends Node

@export var action_manager: Action_Manager
var shift := false
var ctrl := false
var alt := false
var hotkey_map := {}

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
		operation_string += "a"
	elif event.is_action_pressed("b"):
		operation_string += "b"
	elif event.is_action_pressed("c"):
		operation_string += "c"
	elif event.is_action_pressed("d"):
		operation_string += "d"
	elif event.is_action_pressed("e"):
		operation_string += "e"
	elif event.is_action_pressed("f"):
		operation_string += "f"
	elif event.is_action_pressed("g"):
		operation_string += "g"
	elif event.is_action_pressed("h"):
		operation_string += "h"
	elif event.is_action_pressed("i"):
		operation_string += "i"
	elif event.is_action_pressed("j"):
		operation_string += "j"
	elif event.is_action_pressed("k"):
		operation_string += "k"
	elif event.is_action_pressed("l"):
		operation_string += "l"
	elif event.is_action_pressed("m"):
		operation_string += "m"
	elif event.is_action_pressed("n"):
		operation_string += "n"
	elif event.is_action_pressed("o"):
		operation_string += "o"
	elif event.is_action_pressed("p"):
		operation_string += "p"
	elif event.is_action_pressed("q"):
		operation_string += "q"
	elif event.is_action_pressed("r"):
		operation_string += "r"
	elif event.is_action_pressed("s"):
		operation_string += "s"
	elif event.is_action_pressed("t"):
		operation_string += "t"
	elif event.is_action_pressed("u"):
		operation_string += "u"
	elif event.is_action_pressed("v"):
		operation_string += "v"
	elif event.is_action_pressed("w"):
		operation_string += "w"
	elif event.is_action_pressed("x"):
		operation_string += "x"
	elif event.is_action_pressed("y"):
		operation_string += "y"
	elif event.is_action_pressed("z"):
		operation_string += "z"
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
	if(action_manager.designated_action_id != ""):
		for key in hotkey_map:
			if(hotkey_map[key] == action_manager.designated_action_id):
				hotkey_map.erase(key)
		hotkey_map[operation_string] = action_manager.designated_action_id

func trigger(operation_string):
	if(hotkey_map.has(operation_string)):
		var action_id = hotkey_map[operation_string]
		action_manager.full_action_list[action_id].apply()
