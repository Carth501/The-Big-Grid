class_name Dual_Button extends Button

signal left_click
signal right_click

func _ready():
	gui_input.connect(_on_Button_gui_input)

func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
	elif event is InputEventKey and event.keycode == KEY_SPACE and event.pressed:
		left_click.emit()
		
