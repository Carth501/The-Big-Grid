class_name Tag_List_Display extends Control

@export var new_tag_field : LineEdit
@export var tag_container : HFlowContainer
var supply : Supply
var tag_list := {}

func set_supply(new_supply : Supply):
	supply = new_supply
	for tag in supply.tags:
		display_tag(tag)
	supply.tag_added.connect(display_tag)
	supply.tag_removed.connect(delete_tag)

func close():
	supply.tag_added.disconnect(display_tag)
	supply.tag_removed.disconnect(delete_tag)
	for tag_display in tag_list:
		tag_display.queue_free()

func add_tag():
	supply.add_tag(new_tag_field.text)
	new_tag_field.text = ""

func remove_tag(tag_name : String):
	supply.remove_tag(tag_name)

func display_tag(tag : String):
	var tag_display = Tag.new()
	tag_display.set_tag(tag)
	tag_display.clicked.connect(remove_tag)
	tag_container.add_child(tag_display)
	tag_list[tag] = tag_display

func delete_tag(tag : String):
	tag_list[tag].queue_free()
	tag_list.erase(tag)
