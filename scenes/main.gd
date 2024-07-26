extends Node

@export var game_scene: PackedScene
@export var main_menu_scene: PackedScene

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
    # TODO: Setup game signals
    add_child(game)
