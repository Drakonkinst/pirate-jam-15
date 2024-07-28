extends Node2D

class_name Game

signal quit_to_menu

@export var grid: Grid
@export var obstacle_manager: ObstacleManager
@export var projectile_manager: ProjectileManager
@export var pickup_manager: PickupManager
@export var dialogue_manager: DialogueManager
@export var light_manager: LightManager
@export var enemy_spawner: EnemySpawner
@export var toolbar: ToolBar

@onready var pause_control: PauseControl = $PauseControl

func _ready():
    pause_control.unpause()
    # Grid already instantiated since it is a child
    obstacle_manager.spawn_starting_obstacles(grid)
    dialogue_manager.play_conversation(dialogue_manager.current_conversation)

func _on_pause_menu_pressed_quit_to_menu() -> void:
    quit_to_menu.emit()
