class_name Action_Button extends Dual_Button

signal trigger
signal open_action_menu
signal select(action)
signal selection_hover(action)
signal end_selection_hover

var id : String
var action : Action
var audio_stream : Sound_Effect
var action_press_sound : Sound_Effect
var selection_mode := false
var hotkey_controller : Hotkey_Controller
var hotkey_popup : Hotkey_Popup

func _ready() -> void:
	super._ready()
	var directory = AudioEffectControllerSingle.directory
	if(directory.has("button_press")):
		action_press_sound = directory["button_press"]
	hotkey_popup = get_node("/root/Game/HotkeyPopup")

func set_id(new_id : String):
	id = new_id

func connect_logic(new_action : Action):
	action = new_action
	action.update_availability.connect(set_enabled)
	action.update_action_name.connect(change_label)
	change_label(action.get_translation_text())
	set_enabled(action.available)
	if(action.audio != null):
		var directory = AudioEffectControllerSingle.directory
		if(directory.has(action.audio)):
			audio_stream = directory[action.audio]
			trigger.connect(audio_stream.play)
		else:
			if(directory.has("button_press")):
				action_press_sound = directory["button_press"]
			trigger.connect(action_press_sound.play)

func register_hotkey_controller(new_hotkey_controller : Hotkey_Controller):
	hotkey_controller = new_hotkey_controller

func disconnect_action():
	action.update_availability.disconnect(set_enabled)
	action.update_action_name.disconnect(change_label)
	var directory = AudioEffectControllerSingle.directory
	if(action.audio != null && directory.has(action.audio)):
		trigger.disconnect(audio_stream.play)
	else:
		trigger.disconnect(action_press_sound.play)

func actuate():
	if(selection_mode):
		select.emit(action)
		return
	if(!disabled):
		trigger.emit()
	action.apply()

func open_menu():
	open_action_menu.emit()
	action.open()
	if(action_press_sound == null):
		push_warning("action_press_sound is null")
	action_press_sound.play()

func change_label(new_text : String):
	text = new_text

func set_enabled(setting : bool):
	disabled = !setting

func set_filter():
	action.set_filter()
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.update_text("LMB: Activate, RMB: Open action menu, CTRL+Hotkey: set hotkey")
	if(selection_mode):
		selection_hover.emit(action)

func unset_filter():
	action.unset_filter()
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.clear_text()
	if(selection_mode):
		end_selection_hover.emit()

func gain_focus():
	action.gain_focus()

func lose_focus():
	action.lose_focus()

func hover_action():
	action.set_designated_action()
	var has_hotkey = hotkey_controller.map_has_value(id)
	if(has_hotkey):
		var hotkey_text = hotkey_controller.get_key(id)
		hotkey_popup.open(hotkey_text)
		set_popup_pos()
	hotkey_controller.update_to.connect(update_hotkey_popup)

func unhover_action():
	action.release_designated_action()
	hotkey_popup.close()
	hotkey_controller.update_to.disconnect(update_hotkey_popup)

func update_hotkey_popup(update_id : String):
	if(id == update_id):
		var hotkey_text = hotkey_controller.get_key(id)
		hotkey_popup.change_text(hotkey_text)
		set_popup_pos()

func set_popup_pos():
	var x_adjust = size.x / 2 - hotkey_popup.size.x / 2
	hotkey_popup.position = global_position + Vector2(x_adjust, -39)
