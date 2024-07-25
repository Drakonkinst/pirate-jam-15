extends Node

const PLAYER_GROUP := "player"
const POTION_RADIUS := 100

@export var curr_game: Game = null

func get_obstacle_manager() -> ObstacleManager:
    return curr_game.obstacle_manager

func get_projectile_manager() -> ProjectileManager:
    return curr_game.projectile_manager

func get_pickup_manager() -> PickupManager:
    return curr_game.pickup_manager

func get_toolbar() -> ToolBar:
    return curr_game.toolbar

func get_grid() -> Grid:
    return curr_game.grid
