class_name OptionsMenu
extends Control

func _on_exit_button_down() -> void:
	hide()
	SettingsDataContainerSingle.on_settings_save()
