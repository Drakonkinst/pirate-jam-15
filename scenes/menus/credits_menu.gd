extends Control

class_name CreditsMenu

signal pressed_back

@onready var ui_click_audio: AudioStreamPlayer = $UIClickAudio

func _on_return_button_pressed() -> void:
    pressed_back.emit()
    ui_click_audio.play()
