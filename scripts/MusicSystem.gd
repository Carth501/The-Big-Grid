class_name MusicSystem extends Node

@export var music_players: Array[AudioStreamPlayer]
@export var victory_music: AudioStreamPlayer
var index = 0;
var fade_duration = 2;

func _ready() -> void:
	var master_volume = SettingsDataContainerSingle.master_volume
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	var music_volume = SettingsDataContainerSingle.music_volume
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	if(music_players.size() > 0):
		index = randi_range(0, music_players.size() - 1)
	music_players[index].play()

func next_track():
	var new_index = randi_range(0, music_players.size() - 1)
	while(new_index == index):
		new_index = randi_range(0, music_players.size() - 1)
	index = new_index
	music_players[index].play()

func play_victory():
	var tween = create_tween()
	tween.tween_property(music_players[index], "volume_db", -44.768, fade_duration)
	await get_tree().create_timer(fade_duration).timeout
	music_players[index].set_stream_paused(true)
	victory_music.play()
	await victory_music.finished
	music_players[index].set_stream_paused(false)
	tween.tween_property(music_players[index], "volume_db", 44.768, fade_duration)
	
