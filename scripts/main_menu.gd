extends Control

@export var continue_button : Button

func _ready():
	var saves = Save_Handler_Single.get_save_names()
	if(saves == null || saves.size() == 0):
		continue_button.disabled = true

func load_game():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func new_game():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func quit():
	get_tree().quit()
