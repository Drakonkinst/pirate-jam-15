extends Control

class_name StartMenu

signal start_game
signal open_settings
signal open_credits

@onready var ui_click_audio: AudioStreamPlayer = $UIClickAudio
@onready var startup_audio: AudioStreamPlayer = $StartupAudio
@onready var select_play_audio: AudioStreamPlayer = $SelectPlayAudio
# Used to block mouse clicks while screen is still visible
@onready var block_out: ColorRect = $BlockOut

func _ready():
    startup_audio.play()
    block_out.hide()

func on_enable():
    block_out.hide()

func _on_play_button_pressed() -> void:
    select_play_audio.play()
    start_game.emit()

func _on_settings_button_pressed():
    ui_click_audio.play()
    block_out.show()
    open_settings.emit()

func _on_credits_button_pressed():
    ui_click_audio.play()
    block_out.show()
    open_credits.emit()

func _on_exit_button_pressed():
    ui_click_audio.play()
    get_tree().quit()



