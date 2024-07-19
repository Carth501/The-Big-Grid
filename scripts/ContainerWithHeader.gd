extends Control

@export var header : Control
@export var body : Control

func _on_resized() -> void:
	var header_height = header.size.y
	body.offset_top = header_height
