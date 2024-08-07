extends Control

@export var selector : OptionButton

const RESOLUTION_DICTIONARY :Dictionary = {
	"1142 x 648": Vector2i(1152,648),
	"1280 x 720": Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920,1080)
}

func _ready():
	selector.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	selector.select(SettingsDataContainerSingle.resolution_index)
	SettingsDataContainerSingle.resolution_change.connect(on_resolution_selected)

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		selector.add_item(resolution_size_text)

func on_resolution_selected(index: int) -> void:
	SettingsDataContainerSingle.resolution_index = index
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
