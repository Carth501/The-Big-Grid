class_name OptionsMenu
extends Control


@onready var exit: Button = $MarginContainer/VBoxContainer/Exit



func _on_exit_button_down() -> void:
	$".".hide()
