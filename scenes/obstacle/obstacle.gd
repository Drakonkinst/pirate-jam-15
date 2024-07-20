extends Node2D

# Uses inherited scenes to keep child components constant for all types of obstacles
class_name Obstacle

# Some objects can be tramsuted which should overlay their shape with a texture
enum TransmutedState {
    DEFAULT, WOOD, STONE, QUARTZ
}

signal removed

const OBSTACLE_FIRE_DAMAGE: int = 1

var tile: GridTile
var transmuted_state: TransmutedState = TransmutedState.DEFAULT

@onready var health: Health = $Health
@onready var model: ObstacleModel = $ObstacleModel1 # Selects the default obstacle model in case there are no extras
@onready var burning_state: BurningState = $BurningState

@export var data: ObstacleData
@export var alternate_models: Array[ObstacleModel] # Optional array. If there are variations of the same model, can list them all here to choose randomly
@export var behaviors: Array[ObstacleBehavior] # Optional array of behaviors

func _process(_delta: float) -> void:
    for behavior: ObstacleBehavior in behaviors:
        behavior.update(self)

func choose_model() -> void:
    if alternate_models.size() <= 0:
        return
    var choice: int = randi() % alternate_models.size()
    for i in range(alternate_models.size()):
        alternate_models[i].visible = i == choice
    model = alternate_models[choice]

func init_model() -> void:
    choose_model()
    put_out_fire()

    # For demo
    if randf() < 0.5 and data.is_flammable:
        set_on_fire(3)
    if data.id == ObstacleData.Type.TREE:
        set_transmuted_state(Obstacle.TransmutedState.QUARTZ)

func set_tile(obj: GridTile) -> void:
    tile = obj

func damage(value: int) -> void:
    health.damage(value)

func kill() -> void:
    health.kill()

# Only transmute if there is a valid model
func set_transmuted_state(state: TransmutedState) -> bool:
    var success: bool = model.set_transmuted_state(state)
    if success:
        transmuted_state = state
        if burning_state.is_burning() and not is_flammable():
            put_out_fire()
    return success

func set_on_fire(duration: float) -> void:
    if not is_flammable():
        return
    burning_state.start_burning_time(duration)
    model.set_flaming(true, data.should_use_burnt_texture)

func put_out_fire() -> void:
    burning_state.reset_burning_time()
    model.set_flaming(false, data.should_use_burnt_texture)

func is_flammable() -> bool:
    if transmuted_state == TransmutedState.DEFAULT:
        return data.is_flammable
    return transmuted_state == TransmutedState.WOOD

func _ready() -> void:
    init_model()
    health.set_max_health(data.health)
    health.refill_health()

func _on_burning_state_fire_tick() -> void:
    damage(OBSTACLE_FIRE_DAMAGE)

func _on_burning_state_fire_expired() -> void:
    put_out_fire()

func _on_health_death() -> void:
    removed.emit()
