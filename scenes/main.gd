extends Node

const QUIT_INPUT := "ui_cancel"

@export var game_scene: PackedScene
@export var main_menu_scene: PackedScene

@onready var start_game_audio: AudioStreamPlayer = $StartGameAudio

var game: Game
var menu: MainMenu

func _ready() -> void:
	init_main_menu()

func init_main_menu() -> void:
	menu = main_menu_scene.instantiate()
	menu.start_game.connect(start_new_game)
	add_child(menu)

func start_new_game() -> void:
	if menu != null:
		remove_child(menu)
		menu = null
	game = game_scene.instantiate()
	GlobalVariables.curr_game = game
	game.quit_to_menu.connect(quit_to_menu)
	game.restart.connect(restart)
	start_game_audio.play()
	add_child(game)

func quit_to_menu() -> void:
	if game != null:
		remove_child(game)
		game = null
	init_main_menu()

func restart() -> void:
	quit_to_menu()
	start_new_game()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(QUIT_INPUT):
		if not OS.has_feature("web"):
			get_tree().quit()
