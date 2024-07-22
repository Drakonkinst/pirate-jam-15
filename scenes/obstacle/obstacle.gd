extends Node2D

# Uses inherited scenes to keep child components constant for all types of obstacles
class_name Obstacle

enum Type {
    UNKNOWN, TREE, ROCK, TORCH, OIL_SPILL, SAPLING, DEAD_TREE, DEAD_SAPLING
}

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

var burned: bool = false

func _process(delta: float) -> void:
    for behavior: ObstacleBehavior in behaviors:
        # Quick null check just in case
        if behavior:
            behavior.update(self, delta)

func choose_model() -> void:
    if alternate_models.size() <= 0:
        return
    var choice: int = randi() % alternate_models.size()
    for i in range(alternate_models.size()):
        alternate_models[i].visible = i == choice
    model = alternate_models[choice]

func init_model() -> void:
    choose_model()

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
        on_transmuted_state_change()
    return success

func on_transmuted_state_change():
    update_health_from_transmutation(transmuted_state)
    if burning_state.is_burning() and not is_flammable():
        put_out_fire()
    burned = false

# Health updates to match the material after transmutating
func update_health_from_transmutation(state: TransmutedState) -> void:
    # Formula: New Health = (Current Health / Max Health) * Size Multiplier * Material Multiplier
    var health_percent = health.get_percentage()
    var material_multiplier = get_material_multiplier(state)
    #print(health_percent, " ", data.size_multiplier, " ", material_multiplier)
    var new_health: int = ceili(health_percent * data.size_multiplier * material_multiplier)
    var new_max_health: int = ceili(data.size_multiplier * material_multiplier)
    print("Transmutated health ", health_percent, " of ", Type.keys()[data.id], " to ", TransmutedState.keys()[state], " = ", new_health)
    health.set_max_health(new_max_health)
    health.set_health(new_health)

func get_material_multiplier(state: TransmutedState) -> int:
    match state:
        TransmutedState.DEFAULT:
            return data.max_health
        TransmutedState.WOOD:
            return 40
        TransmutedState.STONE:
            return 80
        TransmutedState.QUARTZ:
            return 60
        _:
            print("Unknown material multiplier for transmuted state ", state)
            return data.max_health

func set_on_fire(duration: float) -> void:
    if not is_flammable():
        return
    burning_state.start_burning_time(duration)
    model.set_flaming(true)

func put_out_fire() -> void:
    burning_state.reset_burning_time()
    model.set_flaming(false)

func is_flammable() -> bool:
    if transmuted_state == TransmutedState.DEFAULT:
        return data.is_flammable
    return transmuted_state == TransmutedState.WOOD

func _ready() -> void:
    health.set_max_health(data.health)
    health.refill_health()
    health.invulnerable = data.invulnerable
    put_out_fire()
    init_model()

func _on_burning_state_fire_tick() -> void:
    damage(OBSTACLE_FIRE_DAMAGE)

func _on_burning_state_fire_expired() -> void:
    put_out_fire()

func create_pickup_drop() -> Pickup: 
    var pickup_drop = load("res://scenes/effect/pickup.tscn").instantiate()
    var pickup_type: Pickup.PickupType
    # Making assumption here just because Type is not specified in this class
    match transmuted_state:
        TransmutedState.DEFAULT:
            pickup_type = Pickup.PickupType.GOLD
        TransmutedState.WOOD:
            pickup_type = Pickup.PickupType.SAP
        TransmutedState.QUARTZ:
            pickup_type = Pickup.PickupType.QUARTZ
        TransmutedState.STONE:
            pickup_type = Pickup.PickupType.GOLD
    pickup_drop.set_type(pickup_type)
    pickup_drop.global_position = global_position
    
    #Damn - Logan
    get_parent().get_parent().get_parent().get_parent().add_child(pickup_drop)

    return pickup_drop

func _on_health_death() -> void:
    # TODO: May want to wait a bit for the health to animate before killing?
    # TODO: Maybe health can emit a "finished animation"
    create_pickup_drop()

    removed.emit()

func _on_burning_state_burnt() -> void:
    if data.should_use_burnt_texture:
        model.set_burned_overlay()
        burned = true

func copy_burning_state(state: BurningState) -> void:
    burning_state.burning_time_remaining = state.burning_time_remaining
    burning_state.is_burned = state.is_burned
    burning_state.time_until_next_tick = state.time_until_next_tick
    burning_state.total_time_burned = state.total_time_burned

    if burning_state.is_burned:
        _on_burning_state_burnt()
    if burning_state.is_burning():
        set_on_fire(burning_state.burning_time_remaining)
    else:
        put_out_fire()

