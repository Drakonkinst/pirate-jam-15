extends Node2D

class_name Game

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
@export var grid: Grid
@export var obstacle_manager: ObstacleManager
@export var projectile_manager: ProjectileManager

func _ready():
    # Grid already instantiated since it is a child
    obstacle_manager.spawn_starting_obstacles(grid)

func _input(event):
    if event.is_action_released("ui_cancel"):
        get_tree().quit()
