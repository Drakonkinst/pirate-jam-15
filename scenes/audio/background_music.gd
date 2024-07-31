extends AudioStreamPlayer

class_name BackgroundMusic

@export var tracks: Array[AudioStream]

var current_track := -1

func _ready() -> void:
    switch_track()

func switch_track() -> void:
    var curr_round = GlobalVariables.get_day_cycle_manager().current_round
    if curr_round >= 0 and curr_round < tracks.size():
        stream = tracks[curr_round]
    else:
        pick_random_track()
    play(0.0)

func pick_random_track() -> void:
    var new_track = randi() % tracks.size()
    while new_track == current_track:
        new_track = randi() % tracks.size()
    current_track = new_track


