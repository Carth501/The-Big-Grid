class_name Sound_Effect extends AudioStreamPlayer

@export var id : String

func _ready() -> void:
	if(id == null):
		push_error("no id provided for SoundEffect")
	var directory = AudioEffectControllerSingle.directory
	if(directory.has(id)):
		push_error(str("sound effect id ", id, " already exists"))
	else:
		directory[id]=self
	tree_exited.connect(delist)

func play_audio():
	play()

func delist():
	AudioEffectControllerSingle.directory.erase(id)
