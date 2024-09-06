class_name Sequencers_Display extends ColorRect

@export var editor_container : Waterfall_Container
@export var sequencer_manager : Sequencer_Manager
var sequencer_editor_prefab := preload("res://scenes/display/SequencerEditor.tscn")

func add_editor(id : int):
	var new_editor : Sequencer_Editor = sequencer_editor_prefab.instantiate()
	new_editor.set_sequencer(sequencer_manager.sequencer_list[id])
	editor_container.add_child(new_editor)

func attempt_sequencer_purchaser():
	sequencer_manager.create_sequencer()

func sequencer_purchase_hover():
	sequencer_manager.set_filter()

func sequencer_purchase_exit():
	sequencer_manager.unset_filter()
