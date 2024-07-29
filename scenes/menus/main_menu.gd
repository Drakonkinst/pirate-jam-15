extends Control

class_name MainMenu

signal start_game

@onready var start_menu: StartMenu = %StartMenu
@onready var settings_menu: SettingsMenu = %SettingsMenu
@onready var credits_menu: CreditsMenu = %CreditsMenu

func _ready() -> void:
	GlobalVariables.unmuffle_music()
	get_tree().paused = false
	settings_menu.hide()
	credits_menu.hide()

func _on_start_menu_open_settings() -> void:
	settings_menu.show()

func _on_start_menu_open_credits() -> void:
	credits_menu.show()

func _on_start_menu_start_game() -> void:
	start_game.emit()

func _on_settings_menu_pressed_back() -> void:
	start_menu.on_enable()
	settings_menu.hide()

func _on_credits_menu_pressed_back() -> void:
	start_menu.on_enable()
	credits_menu.hide()
