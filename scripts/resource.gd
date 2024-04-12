class_name resource extends Control

var id := ""
var value := 0
var v_max := 20
var max_increment := 10
var max_upgrade_count := 0
var max_increase_base_cost : Dictionary
@export var name_label : RichTextLabel
@export var value_label : RichTextLabel
@export var max_label : RichTextLabel
@export var delta_label : RichTextLabel
var _resource_popup : resource_popup

func set_id(new_id: String):
	id = new_id
	if(NameTranslatorSingle.translation_data.has(id)):
		var resource_name = NameTranslatorSingle.translation_data[id]
		name_label.text = str("[center]", resource_name, "[center]")
	else:
		name_label.text = str("missing ", id)
	if(ResourceDefsSingle.data.has(id)):
		var data = ResourceDefsSingle.data[id]
		v_max = data.default_max
		max_increment = data.max_increase_increment
		max_increase_base_cost = data.max_increase_base_cost
	update_value()
	update_max()

func test_deltas(deltas: Array) -> bool:
	var dummy_value = value
	for delta in deltas:
		dummy_value += delta
		if(dummy_value < 0 || dummy_value > v_max):
			return false
	return true

func apply_deltas(deltas: Array):
	for delta in deltas:
		value += delta
	update_value()

func update_value():
	value_label.text = str("[center]", value, "[center]")
	
func update_max():
	max_label.text = str("[center]", v_max, "[center]")

func set_resource_popup(popup : resource_popup):
	_resource_popup = popup

func open_popup():
	if(_resource_popup == null):
		push_error("missing resource popup")
	_resource_popup.visible = true
	_resource_popup.set_resource(self)

func set_delta(deltas : Array):
	if(deltas.size() == 0):
		delta_label.text = ""
		return
	var deltas_string = "[center]"
	for delta in deltas:
		if(delta > 0):
			deltas_string += "+"
		deltas_string += str(delta)
	deltas_string += "[center]"
	delta_label.text = deltas_string

func clear_delta():
	delta_label.text = ""
