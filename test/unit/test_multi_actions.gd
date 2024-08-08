extends GutTest

var GridEngine
var machine_factory : Machine_Factory
var supply_collection : Supply_Collection
var action_manager : Action_Manager
var development_handler : Development_Handler
var filter_foreman : Filter_Foreman
var options_overseer : Options_Overseer
var objective_system : Objective_System

var generate_electricity : Dictionary
var bless_water : Dictionary

func before_all():
	GridEngine = load("res://scenes/logic/GridEngine.tscn")
	generate_electricity = ActionsSingle.data["generate_electricity"]
	bless_water = ActionsSingle.data["bless_water"]
	
func before_each():
	get_node('/root/').add_child(GridEngine.instantiate())
	machine_factory = $/root/Logic/MachineFactory
	supply_collection = $/root/Logic/SupplyCollection
	action_manager = $/root/Logic/ActionManager
	development_handler = $/root/Logic/DevelopmentHandler
	filter_foreman = $/root/Logic/FilterForeman
	options_overseer = $/root/Logic/OptionsOverseer
	objective_system = $/root/Logic/ObjectiveSystem

func test_example_change():
	watch_signals(supply_collection)
	supply_collection.apply_changes_mult(generate_electricity.changes, 2)
	assert_signal_emitted(supply_collection, "action_multi")
	assert_signal_emitted_with_parameters(supply_collection, "action_multi", [2])

func test_action_without_reqs():
	watch_signals(supply_collection)
	supply_collection.apply_changes_mult(bless_water.changes, 2)
	assert_signal_emitted(supply_collection, "action_multi")
	assert_signal_emitted_with_parameters(supply_collection, "action_multi", [0])

func test_action_with_limitation():
	watch_signals(supply_collection)
	supply_collection.apply_changes({"purified_water":{"deltas": [1]}})
	supply_collection.apply_changes_mult(bless_water.changes, 2)
	assert_signal_emitted(supply_collection, "action_multi")
	assert_signal_emitted_with_parameters(supply_collection, "action_multi", [1])
