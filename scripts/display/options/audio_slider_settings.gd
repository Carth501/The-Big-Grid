extends Control

@onready var audio_name_lbl: Label = $HBoxContainer/Audio_Name_Lbl
@onready var audio_num_lbl: Label = $HBoxContainer/Audio_Num_Lbl
@onready var h_slider: HSlider = $HBoxContainer/HSlider

@export_enum("Master","Music", "Effects") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	load_data()
	set_name_label_text()
	set_slider_value()

func load_data()-> void:
	match bus_name:
		"Master":
			on_value_changed(SettingsDataContainerSingle.master_volume)
			SettingsDataContainerSingle.master_volume_change.connect(on_value_changed)
		"Music":
			on_value_changed(SettingsDataContainerSingle.music_volume)
			SettingsDataContainerSingle.music_volume_change.connect(on_value_changed)
		"Effects":
			on_value_changed(SettingsDataContainerSingle.effects_volume)
			SettingsDataContainerSingle.music_volume_change.connect(on_value_changed)

func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume"

func set_num_label_text() -> void:
	audio_num_lbl.text = str(h_slider.value * 100) 

func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_num_label_text()

func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	set_num_label_text()

	match bus_index:
		0:
			SettingsDataContainerSingle.master_volume = value
		1:
			SettingsDataContainerSingle.music_volume = value
		2:
			SettingsDataContainerSingle.effects_volume = value
