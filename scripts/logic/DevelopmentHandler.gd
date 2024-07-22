class_name Development_Handler extends Node

@export var action_manager : Action_Manager
@export var supply_collection : Supply_Collection
@export var filter_foreman : Filter_Foreman
var full_development_catalog : Dictionary
@export var developments_enabled := true
var compeleted_developments : Array

func _ready():
	if(developments_enabled):
		for id in DevelopmentsSingle.data:
			build_development(id)

func build_development(id : String):
	var development = Development.new()
	development.setup(id, supply_collection)
	development.set_filter_foreman(filter_foreman)
	full_development_catalog[id] = development

func attempt_development(id : String):
	var candidate : Development = full_development_catalog[id]
	var success = supply_collection.attempt_purchase(candidate.changes)
	if(success):
		candidate.set_complete()
		if(candidate.action_unlocks != null):
			for action_id in candidate.action_unlocks:
				action_manager.create_action(action_id)
		compeleted_developments.append(candidate.id)

func set_completed_developments(previous_devs : Array):
	compeleted_developments = previous_devs
	for dev in compeleted_developments:
		full_development_catalog[dev].set_complete()
