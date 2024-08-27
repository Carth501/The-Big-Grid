class_name Sequencer_Editor extends Control

var sequencer : Sequencer
@export var name_field : LineEdit
@export var tier_value : Label
@export var active_switch : Button
var sequencer_action_item_prefab = preload("res://scenes/display/SequencerActionItem.tscn")
@export var item_list : VBoxContainer


func set_sequencer(new_sequencer : Sequencer):
	sequencer = new_sequencer
	set_sequencer_name_display(sequencer.get_sequencer_name())
	sequencer.name_changed.connect(set_sequencer_name_display)
	set_sequencer_tier_display(sequencer.tier)
	sequencer.tier_changed.connect(set_sequencer_tier_display)
	set_sequencer_active_display(sequencer.get_running())
	sequencer.update_active.connect(set_sequencer_active_display)
	set_pattern(sequencer.pattern)

func set_sequencer_name_display(new_string : String):
	name_field.text = new_string

func set_sequencer_tier_display(new_value : int):
	tier_value.text = str(new_value)

func set_sequencer_active_display(new_value : bool):
	active_switch.set_pressed_no_signal(new_value)

func set_pattern(pattern : Array):
	for action in pattern:
		var new_item = sequencer_action_item_prefab.instantiate()
		item_list.add_child(new_item)
		new_item.set_action(action)
