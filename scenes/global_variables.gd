extends Node

@export var curr_game: Game = null

func get_obstacle_manager() -> ObstacleManager:
    return curr_game.obstacle_manager
