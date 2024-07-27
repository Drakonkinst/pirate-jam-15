extends Node2D

class_name PauseControl

const PAUSE_INPUT := "pause"

signal paused
signal unpaused

@export var on_pause_audio: AudioRandomizer
@export var off_pause_audio: AudioRandomizer

var disabled := false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(PAUSE_INPUT) and not disabled:
        _toggle_pause()

func _toggle_pause() -> void:
    var is_paused: bool = get_tree().paused
    get_tree().paused = not is_paused
    if is_paused:
        unpaused.emit()
        off_pause_audio.play_random()
    else:
        paused.emit()
        on_pause_audio.play_random()

func disable() -> void:
    disabled = true

func enable() -> void:
    disabled = false

func pause() -> void:
    if get_tree().paused:
        return
    _toggle_pause()

func unpause() -> void:
    if not get_tree().paused:
        return
    _toggle_pause()
    print("PLAY")