extends Node

@export var game_scene: PackedScene

var game: Game

func _ready() -> void:
	start_new_game()


func start_new_game() -> void:
	game = game_scene.instantiate()
	GlobalVariables.curr_game = game
	add_child(game)
