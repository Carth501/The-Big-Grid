extends Control

@export var objective_text : Label

func update_objective(new_obj : String):
	objective_text.text = new_obj
