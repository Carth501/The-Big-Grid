class_name Supply_Label extends PanelContainer

@export var v_box : VBoxContainer
@export var supply_name_label : Label
@export var supply_description_label : Label

func show_name(supply_name_string: String):
	show()
	supply_name_label.text = supply_name_string

func show_description(supply_description_string: String):
	supply_description_label.show()
	supply_description_label.text = supply_description_string

func hide_name():
	hide_description()
	hide()

func hide_description():
	supply_description_label.hide()
	supply_description_label.text = ""
	v_box.reset_size()
	reset_size()

func move_to_supply_rect(supply_rect : Rect2):
	if(supply_rect.position.y - size.y > 0):
		position.y = supply_rect.position.y - size.y
	else:
		position.y = supply_rect.position.y + supply_rect.size.y
	position.x = supply_rect.position.x
