class_name OptionsMenu
extends Control


@onready var exit: Button = $MarginContainer/VBoxContainer/Exit



func _on_exit_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
