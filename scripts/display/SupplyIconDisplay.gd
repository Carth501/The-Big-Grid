class_name Supply_Icon_Display extends Control

@export var texture_rect : TextureRect
@export var panel_container : PanelContainer
@export var label : Label

func set_image_by_path(path : String):
	var image = load(path)
	texture_rect.set_texture(image)

func set_supply_name(new_name : String):
	label.text = new_name

func show_label():
	panel_container.visible = true

func hide_label():
	panel_container.visible = false
