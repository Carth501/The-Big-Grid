class_name Pause_Handler extends Node

signal toggle_display(show_menu : bool)
var locked := false

func _ready():
	Logic_Directory_Single.index_object("Pause_Handler", self)

func pause_or_unpause():
	if (!locked):
		if get_tree().paused == true: #if game is paused, pressing resume will unpause it
			get_tree().paused = false
			toggle_display.emit(false)
		elif get_tree().paused == false: #if game is unpaused, pressing escape will pause it
			get_tree().paused = true
			toggle_display.emit(true)

func _quitGame(): #Quits to main menu
	get_tree().paused = false #unpauses tree so main menu can be clicked
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn") #changes scene to main menu
