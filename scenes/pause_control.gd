extends Node2D

class_name PauseControl

const PAUSE_INPUT := "pause"

signal paused
signal unpaused

var disabled := false

func _input(event) -> void:
    if event.is_action_pressed(PAUSE_INPUT) and not disabled:
        _toggle_pause()

func _toggle_pause() -> void:
    var is_paused: bool = get_tree().paused
    get_tree().paused = not is_paused
    if is_paused:
        unpaused.emit()
    else:
        paused.emit()

func disable() -> void:
    disabled = true

func pause() -> void:
    if get_tree().paused:
        return
    _toggle_pause()

func unpause() -> void:
    if not get_tree().paused:
        return
    _toggle_pause()