class_name Options_Overseer extends Node

signal update_keep_positions(setting : bool)
signal initialize_keep_positions(setting : bool)
signal update_focus_filtering(setting : bool)

func _ready() -> void:
	initialize_keep_positions.emit(SettingsDataContainerSingle.keep_positions)
	update_keep_positions.connect(SettingsDataContainerSingle.set_keep_position)
	set_focus_filtering(SettingsDataContainerSingle.focus_filtering)

func set_keep_positions(setting : bool):
	update_keep_positions.emit(setting)

func set_focus_filtering(setting : bool):
	update_focus_filtering.emit(setting)
