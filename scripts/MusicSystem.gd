extends Node

@export var music_players: Array[AudioStreamPlayer]
var index = 0;

func _ready() -> void:
	if(music_players.size() > 0):
		index = randi_range(0, music_players.size() - 1)
		music_players[index].play()

func next_track():
	var new_index = randi_range(0, music_players.size() - 1)
	while(new_index == index):
		new_index = randi_range(0, music_players.size() - 1)
	index = new_index
	music_players[index].play()
