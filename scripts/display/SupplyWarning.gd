class_name Supply_Warning extends TextureRect

@export var warning_text : Label
@export var warning_panel : PanelContainer

func add_text(warning : String):
	warning_text.text += warning

func set_text(warning : String):
	warning_text.text = warning

func open_warning():
	warning_panel.visible = true

func close_warning():
	warning_panel.visible = false
