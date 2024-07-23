extends VSplitContainer

@export var split := 0.6

func _on_dragged(offset: int) -> void:
	split = offset / size.y

func _on_resized() -> void:
	split_offset = roundi(size.y * split)
