class_name Action_Button extends Dual_Button

signal trigger
signal open_action_menu

var id : String
var action : Action
var audio_stream : Sound_Effect
var action_press_sound : Sound_Effect

func _ready() -> void:
	super._ready()
	var directory = AudioEffectControllerSingle.directory
	if(directory.has("button_press")):
		action_press_sound = directory["button_press"]

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

func disconnect_action():
	action.update_availability.disconnect(set_enabled)
	action.update_action_name.disconnect(change_label)
	var directory = AudioEffectControllerSingle.directory
	if(action.audio != null && directory.has(action.audio)):
		trigger.disconnect(audio_stream.play)
	else:
		trigger.disconnect(action_press_sound.play)

func actuate():
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

func unset_filter():
	action.unset_filter()

func gain_focus():
	action.gain_focus()

func lose_focus():
	action.lose_focus()
