class_name Options_Overseer extends Node

signal update_keep_positions(bool)
signal update_focus_filtering(bool)

func set_keep_positions(setting : bool):
	update_keep_positions.emit(setting)

func set_focus_filtering(setting : bool):
	update_focus_filtering.emit(setting)
