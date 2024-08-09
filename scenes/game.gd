extends Node2D

class_name Game

signal quit_to_menu
signal restart

@export var grid: Grid
@export var obstacle_manager: ObstacleManager
@export var projectile_manager: ProjectileManager
@export var pickup_manager: PickupManager
@export var dialogue_manager: DialogueManager
@export var light_manager: LightManager
@export var enemy_spawner: EnemySpawner
@export var toolbar: ToolBar
@export var day_cycle_manager: DayCycleManager
@export var base_health: BaseHealth
@export var game_over_screen: GameOverMenu
@export var pause_control: PauseControl

var score: int = 0
var sprites_killed: int = 0
var golems_killed: int = 0
var is_game_over: bool = false

var game_result = ""

func _ready():
    pause_control.unpause()
    # Grid already instantiated since it is a child
    obstacle_manager.spawn_starting_obstacles(grid)
    # dialogue_manager.play_conversation(dialogue_manager.current_conversation)
    day_cycle_manager.start_day()

func _on_pause_menu_pressed_quit_to_menu() -> void:
    quit_to_menu.emit()

func _on_base_health_game_over() -> void:
    pause_control.disable()
    get_tree().paused = true
    game_over_screen.enable()
    is_game_over = true

func damage_player(amount: int) -> void:
    base_health.damage(amount)

func _on_game_over_menu_quit_to_menu() -> void:
    quit_to_menu.emit()

func _on_game_over_menu_restart() -> void:
    restart.emit()

func _on_victory_menu_restart():
    restart.emit()
    
func _on_victory_menu_quit_to_menu():
    quit_to_menu.emit()
