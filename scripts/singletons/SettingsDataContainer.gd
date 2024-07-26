extends Node

signal windowed_mode_change(index : int)
signal resolution_change(index : int)
signal master_volume_change(level : float)
signal music_volume_change(level : float)
signal effects_volume_change(level : float)
signal keep_position_change(float)

var window_mode_index: int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0
var effects_volume: float = 0.0
var keep_positions : bool = true
var focus_filtering : bool = false

var loaded_data : Dictionary

const SETTINGS_SAVE_PATH : String = "user://settings.cfg"

var settings_data_dict : Dictionary = {}
var default_settings_data := {
		"window_mode_index" : 0,
		"resolution_index" : 0,
		"master_volume" : 50,
		"music_volume" : 50,
		"effects_volume" : 50
	}

func _ready():
	load_settings_data()

func get_window_mode_index() -> int:
	return window_mode_index
	
func get_resolution_index() -> int:
	return resolution_index

func get_master_volume() -> float:
	return master_volume

func get_music_volume() -> float:
	return music_volume

func get_effects_volume() -> float:
	return effects_volume
	
func set_keep_position(new_setting : bool):
	keep_positions = new_setting
	on_settings_save()

func on_settings_save() -> void:
	var config = ConfigFile.new()

	config.set_value("Video", "window_mode_index", window_mode_index)
	config.set_value("Video", "resolution_index", resolution_index)
	config.set_value("Audio", "master_volume", master_volume)
	config.set_value("Audio", "music_volume", music_volume)
	config.set_value("Audio", "effects_volume", effects_volume)
	config.set_value("Customization", "keep_positions", keep_positions)
	config.set_value("Customization", "focus_filtering", focus_filtering)
	
	config.save(SETTINGS_SAVE_PATH)
	
	
func load_settings_data() -> void:
	var config = ConfigFile.new()

	var err = config.load(SETTINGS_SAVE_PATH)

	if err != OK:
		window_mode_index = default_settings_data["window_mode_index"]
		resolution_index = default_settings_data["resolution_index"]
		master_volume = default_settings_data["master_volume"]
		music_volume = default_settings_data["music_volume"]
		effects_volume = default_settings_data["effects_volume"]
	else:
		window_mode_index = config.get_value("Video", "window_mode_index", 0)
		resolution_index = config.get_value("Video", "resolution_index", 0)
		master_volume = config.get_value("Audio", "master_volume", 50)
		music_volume = config.get_value("Audio", "music_volume", 50)
		effects_volume = config.get_value("Audio", "effects_volume", 50)
		keep_positions = config.get_value("Customization", "keep_positions", true)
		focus_filtering = config.get_value("Customization", "focus_filtering", false)

