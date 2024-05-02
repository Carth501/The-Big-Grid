class_name Dev_Button extends Button

signal attempt(id : String)
var id : String
var development : Development
var complete := false
@export var description_popup : PanelContainer
@export var description : Label

func set_id(new_id : String):
	id = new_id

func connect_to_logic(dev : Development):
	dev.complete.connect(finish)
	disabled = dev.completed
	dev.update_availability.connect(set_enabled)
	set_enabled(dev.available)
	set_strings(dev.translated_strings)
	dev.update_translations.connect(set_strings)
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
	unset_hover()
	visible = false

func set_enabled(setting):
	if(!complete):
		disabled = !setting

func trigger():
	if(!complete):
		attempt.emit(id)

func set_hover():
	if(!complete):
		development.set_filter()
	if(description.text != null && description.text != ""):
		description_popup.visible = true

func unset_hover():
	development.unset_filter()
	description_popup.visible = false

func gain_focus():
	if(!complete):
		development.gain_focus()

func lose_focus():
	development.lose_focus()
