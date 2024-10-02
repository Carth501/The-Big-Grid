class_name Supply_Icon_Display extends Control

@export var texture_rect : TextureRect

func set_image_by_path(path : String):
	var image = load(path)
	texture_rect.set_texture(image)
