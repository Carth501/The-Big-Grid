class_name Waterfall_Container extends Container

@export_range(2, 2000) var column_width := 200
@export_range(2, 2000) var spacing := 8

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		organize_children()

func set_some_setting():
	# Some setting changed, ask for children re-sort.
	queue_sort()

func organize_children():
	var column_count = floori(size.x / (column_width + spacing))
	var column_depths := []
	if(column_count == 0):
		var minimum_size = get_custom_minimum_size()
		minimum_size.x = column_width
		set_custom_minimum_size(minimum_size)
		column_count = 1
	for x in column_count:
		column_depths.push_front(0)
	for c in get_children():
		var column_index = get_shortest_column(column_depths, column_count)
		c.position = Vector2(
			column_index * (column_width + spacing), 
			column_depths[column_index]
			)
		column_depths[column_index] += c.size.y

func get_shortest_column(columns : Array, column_count : int) -> int:
	var shortest_index := 0
	if(columns.size() < column_count):
		return columns.size()
	var index := 0
	for column in columns:
		if(column < columns[shortest_index]):
			shortest_index = index
		index += 1
	return shortest_index
	
