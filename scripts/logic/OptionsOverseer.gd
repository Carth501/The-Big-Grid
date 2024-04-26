class_name Options_Overseer extends Node

signal update_keep_positions(bool)

func set_keep_positions(setting : bool):
	update_keep_positions.emit(setting)
