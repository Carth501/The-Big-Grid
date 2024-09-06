class_name Sequencer_Editor extends Control

signal set_filter(cost)
signal unset_filter()

var sequencer : Sequencer
@export var name_field : LineEdit
@export var tier_value : Label
@export var active_switch : Button
@export var interval_field : SpinBox
var sequencer_action_item_prefab = preload("res://scenes/display/SequencerActionItem.tscn")
@export var item_list : VBoxContainer
var action_slots : Array = []
var action_slot_cost := {
			"modular_computer": {
				"deltas": [
					-2
				]
			}
		}

func set_sequencer(new_sequencer : Sequencer):
	sequencer = new_sequencer
	set_sequencer_name_display(sequencer.get_sequencer_name())
	sequencer.name_changed.connect(set_sequencer_name_display)
	set_sequencer_tier_display(sequencer.tier)
	sequencer.tier_changed.connect(set_sequencer_tier_display)
	set_sequencer_active_display(sequencer.get_running())
	sequencer.update_active.connect(set_sequencer_active_display)
	set_pattern(sequencer.pattern)
	sequencer.add_action.connect(change_action)
	sequencer.remove_action.connect(clear_action)
	interval_field.value = sequencer.timer.wait_time

func set_sequencer_name_display(new_string : String):
	name_field.text = new_string

func set_sequencer_tier_display(new_value : int):
	tier_value.text = str(new_value)

func set_sequencer_active_display(new_value : bool):
	active_switch.set_pressed_no_signal(new_value)

func set_pattern(pattern : Array):
	var index = 0
	for action in pattern:
		if(index >= action_slots.size()):
			add_action_slot()
		var slot = action_slots[index]
		slot.set_action(action)
		index += 1
	while index < action_slots.size():
		action_slots[index].visible = false
		index += 1

func add_action_slot():
	var new_item = sequencer_action_item_prefab.instantiate()
	item_list.add_child(new_item)
	item_list.move_child(new_item, action_slots.size())
	new_item.set_action(null)
	new_item.set_index(action_slots.size())
	action_slots.push_back(new_item)
	new_item.begin_fill.connect(begin_add_action)
	new_item.remove.connect(clear_index)

func purchase_action_slot():
	add_action_slot()
	sequencer.add_slot()

func begin_add_action(index : int):
	sequencer.begin_slot_fill(index)

func change_action(index : int, action : Action):
	action_slots[index].set_action(action)

func clear_action(index : int):
	action_slots[index].set_action(null)

func clear_index(index : int):
	sequencer.clear_slot(index)

func set_interval(value : float):
	sequencer.set_interval(value)

func set_action_slot_purchase_filter() -> void:
	set_filter.emit(action_slot_cost)

func filter_end() -> void:
	unset_filter.emit()
