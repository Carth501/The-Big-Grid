extends Control

@export var selector : OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
	]

func _ready():
	selector.item_selected.connect(on_selected)
	add_window_mode_items()
	selector.select(SettingsDataContainerSingle.window_mode_index)
	on_selected(SettingsDataContainerSingle.window_mode_index)
	SettingsDataContainerSingle.windowed_mode_change.connect(on_selected)

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		selector.add_item(window_mode)

func on_selected(index: int) -> void:
	SettingsDataContainerSingle.window_mode_index = index
	match  index: 
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless FullScreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
