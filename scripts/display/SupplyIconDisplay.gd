class_name Supply_Icon_Display extends Control

signal being_hovered(index)
signal end_hovered()
@export var texture_rect : TextureRect
var index := 0

func set_image_by_path(path : String):
	var image = load(path)
	texture_rect.set_texture(image)

func enter():
	being_hovered.emit(index)

func exit():
	end_hovered.emit()
