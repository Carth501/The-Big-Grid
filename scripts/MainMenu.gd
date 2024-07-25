extends Control

@export var continue_button : Button
@export var load_panel : PanelContainer
@export var load_buttons_container : VBoxContainer
@export var fade_duration : float = 0.5

func _ready():
	var saves = Save_Handler_Single.get_save_metadata()
	if(saves == null || saves.size() == 0):
		continue_button.disabled = true
	else:
		continue_button.disabled = false
		for save in saves:
			var save_selection = Load_Game_Button.new()
			save_selection.set_file_name(save["file_name"])
			load_buttons_container.add_child(save_selection)
			save_selection.select_save.connect(load_game)

func continue_game():
	Save_Handler_Single.prepare_recent_save()
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -44.768, fade_duration )
	await get_tree().create_timer(fade_duration).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func toggle_load_panel():
	load_panel.visible = !load_panel.visible

func load_game(file_name : String):
	Save_Handler_Single.prepare_save(file_name)
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -44.768, fade_duration )
	await get_tree().create_timer(fade_duration).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func new_game():
	#Save_Handler_Single.clear_save()
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -44.768, fade_duration )
	await get_tree().create_timer(fade_duration).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func quit():
	get_tree().quit()


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
