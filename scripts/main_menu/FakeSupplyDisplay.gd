extends Control

@export var supply_icon : Supply_Icon_Display

func set_icon(path : String):
	supply_icon.set_image_by_path(path)
