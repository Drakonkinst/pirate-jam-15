extends CanvasLayer

class_name PauseMenu

signal pressed_quit_to_menu

@export var pause_control: PauseControl

@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var ui_click_audio: AudioStreamPlayer = $UIClickAudio

func _ready() -> void:
    hide()
    settings_menu.hide()

func _on_pause_control_unpaused() -> void:
    hide()
    GlobalVariables.unmuffle_music()

func _on_pause_control_paused() -> void:
    show()
    settings_menu.hide()
    GlobalVariables.muffle_music()

func _on_settings_button_pressed() -> void:
    settings_menu.show()
    ui_click_audio.play()

func _on_settings_menu_pressed_back() -> void:
    settings_menu.hide()

func _on_resume_button_pressed() -> void:
    pause_control.unpause()
    ui_click_audio.play()

func _on_quit_to_menu_button_pressed() -> void:
    pressed_quit_to_menu.emit()
