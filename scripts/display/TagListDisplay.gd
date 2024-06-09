class_name Tag_List_Display extends Control

@export var new_tag_field : LineEdit
@export var tag_container : HFlowContainer
var target
var tag_list := {}

func set_target(new_target):
	if(tag_list != {}):
		destroy_all_tags()
	target = new_target
	for tag in target.tags:
		display_tag(tag)
	target.tag_added.connect(display_tag)
	target.tag_removed.connect(delete_tag)

func close():
	if(target != null && target.is_connected("tag_added", display_tag)):
		target.tag_added.disconnect(display_tag)
	if(target != null && target.is_connected("tag_removed", delete_tag)):
		target.tag_removed.disconnect(delete_tag)
	destroy_all_tags()

func add_tag(_value = 0):
	target.add_tag(new_tag_field.text)
	new_tag_field.text = ""

func remove_tag(tag_name : String):
	target.remove_tag(tag_name)

func display_tag(tag : String):
	var tag_display = Tag.new()
	tag_display.set_tag(tag)
	tag_display.clicked.connect(remove_tag)
	tag_container.add_child(tag_display)
	tag_list[tag] = tag_display

func delete_tag(tag : String):
	tag_list[tag].queue_free()
	tag_list.erase(tag)

func destroy_all_tags():
	for tag in tag_list:
		tag_list[tag].queue_free()
