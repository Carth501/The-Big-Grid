extends ColorRect

var icon_prefab = preload("res://scenes/MainMenu/FakeSupplyDisplay.tscn")
@export var icon_container : HFlowContainer
@export var icon_list : Array[String]

func _on_resized() -> void:
	var rows = roundi(size.y / 64)
	var columns = roundi(size.x / 64)
	var count = rows * columns
	var difference = count - icon_container.get_child_count()
	while (difference > 0):
		var new_icon = icon_prefab.instantiate()
		icon_container.add_child(new_icon)
		new_icon.set_icon(get_random_icon_path())
		difference -= 1

func get_random_icon_path() -> String:
	return icon_list.pick_random()
