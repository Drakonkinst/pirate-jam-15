extends Node

const PLAYER_GROUP := "player"
const POTION_RADIUS := 100
const CONFIG_PATH = "user://settings.cfg"

# Light radius
const TORCH_LIGHT_RADIUS := 200.0
const FLAMING_OBJECT_LIGHT_RADIUS := 175.0
const FLAMING_ENEMY_LIGHT_RADIUS := 175.0
const QUARTZ_LIGHT_RADIUS := 250.0
const QUARTZ_CRYSTAL_LIGHT_RADIUS := 200.0

# Fire durations
const TORCH_FIRE_DURATION := 5.0
const FIRE_SPREAD_DURATION := 5.0

@export var curr_game: Game = null

var config := ConfigFile.new()
var music := AudioServer.get_bus_index("Music")
var effects := AudioServer.get_bus_index("Effects")

func get_obstacle_manager() -> ObstacleManager:
    return curr_game.obstacle_manager

func get_projectile_manager() -> ProjectileManager:
    return curr_game.projectile_manager

func get_light_manager() -> LightManager:
    return curr_game.light_manager

func get_base_health() -> BaseHealth:
    return curr_game.base_health

func get_dialogue_manager() -> DialogueManager:
    return curr_game.dialogue_manager

func get_pickup_manager() -> PickupManager:
    return curr_game.pickup_manager

func get_enemy_spawner() -> EnemySpawner:
    return curr_game.enemy_spawner

func get_toolbar() -> ToolBar:
    return curr_game.toolbar

func get_grid() -> Grid:
    return curr_game.grid

func get_day_cycle_manager() -> DayCycleManager:
    return curr_game.day_cycle_manager

func get_background_music() -> BackgroundMusic:
    return curr_game.background_music

func _load_config() -> void:
    var err := config.load(CONFIG_PATH)
    if err == OK:
        if config.has_section_key("audio", "music"):
            set_music_volume(config.get_value("audio", "music"), false)
        else:
            set_music_volume(1.0, false)
        if config.has_section_key("audio", "effects"):
            set_effects_volume(config.get_value("audio", "effects"), false)
        else:
            set_effects_volume(1.0, false)
        config.save(CONFIG_PATH)

func muffle_music() -> void:
    AudioServer.get_bus_effect(music, 0).resonance = 0.1

func unmuffle_music() -> void:
    AudioServer.get_bus_effect(music, 0).resonance = 0.5

func set_music_volume(value: float, save: bool = true) -> void:
    AudioServer.set_bus_volume_db(music, linear_to_db(value))
    if save:
        config.set_value("audio", "music", value)
        config.save(CONFIG_PATH)

func set_effects_volume(value: float, save: bool = true) -> void:
    AudioServer.set_bus_volume_db(effects, linear_to_db(value))
    if save:
        config.set_value("audio", "effects", value)
        config.save(CONFIG_PATH)

func get_music_volume() -> float:
    return db_to_linear(AudioServer.get_bus_volume_db(music))

func get_effects_volume() -> float:
    return db_to_linear(AudioServer.get_bus_volume_db(effects))
