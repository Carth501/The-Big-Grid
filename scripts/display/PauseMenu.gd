class_name Pause_Menu extends Control

@export var resume_button : Button
@export var pause_handler : Pause_Handler

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_handler.pause_or_unpause()

func toggle_pause(show_menu : bool):
	if(show_menu):
		show()
		resume_button.grab_focus()
	else:
		hide()

func _quitGame():
	pause_handler._quitGame()
