extends AudioStreamPlayer

@export var loop_audio: AudioStream

var started_looping: bool = false
# When it finishes for the first time, start looping
func _on_finished() -> void:
    if not started_looping:
        started_looping = true
        stream = loop_audio
        play()
