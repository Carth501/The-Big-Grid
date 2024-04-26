class_name Dual_Button extends Button

signal left_click
signal right_click

func _ready():
	gui_input.connect(_handle_input)

func _handle_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
	elif event.is_action_pressed("space"):
		left_click.emit()
	elif event.is_action_pressed("cancel"):
		release_focus()
