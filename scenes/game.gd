extends Node2D

class_name Game

signal quit_to_menu

@export var grid: Grid
@export var obstacle_manager: ObstacleManager
@export var projectile_manager: ProjectileManager
@export var pickup_manager: PickupManager
@export var toolbar: ToolBar

@onready var pause_control: PauseControl = $PauseControl

func _ready():
    pause_control.unpause()
    # Grid already instantiated since it is a child
    obstacle_manager.spawn_starting_obstacles(grid)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("ui_cancel"):
        get_tree().quit()

func _on_pause_menu_pressed_quit_to_menu() -> void:
    quit_to_menu.emit()
