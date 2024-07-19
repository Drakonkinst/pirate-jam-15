extends Node2D

class_name Game

@export var grid: Grid
@export var obstacle_manager: ObstacleManager

func _ready():
    # Grid already instantiated since it is a child
    obstacle_manager.spawn_starting_obstacles(grid)

func _input(event):
    if event.is_action_released("ui_cancel"):
        get_tree().quit()
