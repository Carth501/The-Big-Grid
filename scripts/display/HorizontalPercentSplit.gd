extends HSplitContainer

@export var split := 0.6

func _on_dragged(offset: int) -> void:
	split = offset / size.x

func _on_resized() -> void:
	split_offset = size.x * split
