extends Node

signal windowed_mode_change(int)
signal resolution_change(int)
signal master_volume_change(float)
signal music_volume_change(float)

var window_mode_index: int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0

var loaded_data : Dictionary

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"

var settings_data_dict : Dictionary = {}
var default_settings_data := {
		"window_mode_index" : 0,
		"resolution_index" : 0,
		"master_volume" : 100,
		"music_volume" : 100
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

func on_settings_save() -> void:
	var config = ConfigFile.new()

	config.set_value("Video", "window_mode_index", window_mode_index)
	config.set_value("Video", "resolution_index", resolution_index)
	config.set_value("Audio", "master_volume", master_volume)
	config.set_value("Audio", "music_volume", music_volume)
	
	config.save("user://settings.cfg")
	
	
func load_settings_data() -> void:
	var config = ConfigFile.new()

	var err = config.load("user://settings.cfg")

	if err != OK:
		window_mode_index = default_settings_data["window_mode_index"]
		resolution_index = default_settings_data["resolution_index"]
		master_volume = default_settings_data["master_volume"]
		music_volume = default_settings_data["music_volume"]
	else:
		window_mode_index = config.get_value("Video", "window_mode_index")
		resolution_index = config.get_value("Video", "resolution_index")
		master_volume = config.get_value("Audio", "master_volume")
		music_volume = config.get_value("Audio", "music_volume")

