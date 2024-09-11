class_name Dev_Button extends Dual_Button

signal attempt(id : String)
signal deindex(id : String)
var id : String
var development : Development
var complete := false
var revealed := false
@export var description_popup : PanelContainer
@export var description : Label

func _ready() -> void:
	super._ready()
	visible = false

func set_id(new_id : String):
	id = new_id

func connect_to_logic(dev : Development):
	dev.complete.connect(finish)
	disabled = dev.completed
	dev.update_availability.connect(set_enabled)
	set_enabled(dev.available)
	set_strings(dev.translated_strings)
	dev.update_translations.connect(set_strings)
	dev.reveal.connect(reveal)
	development = dev

func set_strings(new_strings : Dictionary):
	text = new_strings.label
	if(new_strings.has("description")):
		var description_string = str(text, "\n",  new_strings.description)
		description.text = description_string

func finish():
	disabled = true
	release_focus()
	complete = true
	revealed = false
	unset_hover()
	deindex.emit(id)
	queue_free()

func set_enabled(setting):
	if(!complete):
		disabled = !setting

func trigger():
	if(!complete):
		attempt.emit(id)
		play_sound()

func set_hover():
	if(!complete):
		development.set_filter()
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.update_text("LMB: Activate, RMB: Hide Development")
	if(description.text != null && description.text != ""):
		description_popup.visible = true

func unset_hover():
	development.unset_filter()
	var controls_display = $/root/Game/Display/Panel/ControlsLabel
	if(controls_display != null):
		controls_display.clear_text()
	description_popup.visible = false

func gain_focus():
	if(!complete):
		development.gain_focus()

func lose_focus():
	development.lose_focus()

func reveal():
	if(!complete):
		revealed = true
		visible = true

func play_sound():
	var directory = AudioEffectControllerSingle.directory
	if(directory.has("development")):
		directory["development"].play()
	else:
		push_warning("directory does not have development sound.")

func hide_temporarily():
	visible = false
