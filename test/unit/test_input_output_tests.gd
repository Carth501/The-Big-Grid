extends GutTest

var GridEngine
var machine_factory : Machine_Factory
var supply_collection : Supply_Collection
var action_manager : Action_Manager
var development_handler : Development_Handler
var filter_foreman : Filter_Foreman
var options_overseer : Options_Overseer
var objective_system : Objective_System

func before_all():
	GridEngine = load("res://scenes/logic/GridEngine.tscn")
	
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
	var gold = supply_collection.get_supply("gold_ingot")
	assert_not_null(gold)
	supply_collection.apply_changes({"gold_ingot":{"deltas": [1]}})
	assert_eq(gold.value, 1)
