extends Node

const PLAYER_GROUP = "player"

@export var curr_game: Game = null

func get_obstacle_manager() -> ObstacleManager:
    return curr_game.obstacle_manager

func get_projectile_manager() -> ProjectileManager:
    return curr_game.projectile_manager

func get_grid() -> Grid:
    return curr_game.grid
