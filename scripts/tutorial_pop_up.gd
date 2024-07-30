extends ColorRect


func _on_exit_pressed() -> void:
	$".".hide()


func _on_supplies_menu_pressed() -> void:
	$SuppliesTutorial.show()


func _on_close_pressed() -> void:
	$SuppliesTutorial.hide()


func _on_action_menu_pressed() -> void:
	$ActionMenuTutorial.show()

func _on_close_action_pressed() -> void:
	$ActionMenuTutorial.hide()
