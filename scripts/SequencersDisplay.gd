class_name Sequencers_Display extends ColorRect

@export var editor_container : Waterfall_Container
@export var sequencer_manager : Sequencer_Manager
@export var branch_access_prompt : ColorRect
var sequencer_editor_prefab := preload("res://scenes/display/SequencerEditor.tscn")
var supply_display_prefab := preload("res://scenes/display/SupplyDisplay.tscn")
var sequencer_ref : Sequencer
var action_ref : Action
@export var supply_list_container : HFlowContainer
@export var supply_collection : Supply_Collection
@export var options_overseer : Options_Overseer
var supply_displays := []

func add_editor(id : int):
	var new_editor : Sequencer_Editor = sequencer_editor_prefab.instantiate()
	var sequencer = sequencer_manager.sequencer_list[id]
	new_editor.set_sequencer(sequencer)
	editor_container.add_child(new_editor)
	new_editor.set_filter.connect(set_filter)
	new_editor.unset_filter.connect(filter_end)
	sequencer.open_branch_access_prompt.connect(open_branch_access_prompt)

func attempt_sequencer_purchaser():
	sequencer_manager.create_sequencer()

func sequencer_purchase_hover():
	sequencer_manager.set_sequencer_cost_filter()

func set_filter(cost : Dictionary):
	sequencer_manager.set_filter(cost)

func filter_end():
	sequencer_manager.unset_filter()

func open_branch_access_prompt(sequencer : Sequencer):
	branch_access_prompt.visible = true
	sequencer_ref = sequencer
	action_ref = sequencer_ref.action_decision
	if(action_ref.branches.size() == 0):
		return
	var branch = action_ref.branches[0]
	var branch_cost = BranchesSingle.data[branch].access_cost
	for supply_id in branch_cost:
		var new_display = supply_display_prefab.instantiate()
		new_display.setup(supply_id, supply_collection, options_overseer)
		supply_list_container.add_child(new_display)
		supply_displays.append(new_display)
		new_display.set_delta_display(branch_cost[supply_id].deltas)
		new_display.visible = true

func accept_branch_access_prompt():
	sequencer_ref.purchase_branch_access()
	close_branch_access_prompt()

func close_branch_access_prompt():
	for display in supply_displays:
		display.queue_free()
	supply_displays.clear()
	branch_access_prompt.visible = false
