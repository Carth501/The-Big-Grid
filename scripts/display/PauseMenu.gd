extends Control

@export var resume_button : Button

#Make sure root node process is set to always or will not work properly
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): #Takes input  for pause key
		pause_or_unpause() #executes pause/unpause function

func pause_or_unpause():
		if get_tree().paused == true: #if game is paused, pressing resume will unpause it
			hide()
			get_tree().paused = false
		elif get_tree().paused == false: #if game is unpaused, pressing escape will pause it
			show()
			get_tree().paused = true
			resume_button.grab_focus()

func _quitGame(): #Quits to main menu
	get_tree().paused = false #unpauses tree so main menu can be clicked
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn") #changes scene to main menu
