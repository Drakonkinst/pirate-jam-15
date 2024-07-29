extends AudioStreamPlayer

class_name FireAudio

func _process(_delta: float) -> void:
    var any_fire = GlobalVariables.get_light_manager().any_fire()
    if any_fire and not playing:
        playing = true
    elif not any_fire and playing:
        playing = false

