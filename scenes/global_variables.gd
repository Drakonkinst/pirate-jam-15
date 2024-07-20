extends Node

@export var curr_game: Game = null

func get_obstacle_manager() -> ObstacleManager:
    return curr_game.obstacle_manager

func get_player() -> Player:
    return curr_game.player

func get_grid() -> Grid:
    return curr_game.grid