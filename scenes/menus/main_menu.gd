extends Control

class_name MainMenu

signal start_game

@onready var start_menu: StartMenu = %StartMenu
@onready var settings_menu: SettingsMenu = %SettingsMenu

func _on_start_menu_open_settings() -> void:
    settings_menu.show()
    pass

func _on_start_menu_open_credits() -> void:
    # TODO
    pass

func _on_start_menu_start_game() -> void:
    start_game.emit()

func _on_settings_menu_pressed_back() -> void:
    start_menu.on_enable()
    settings_menu.hide()
