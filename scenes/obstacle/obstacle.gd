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
signal transmuted(obstacle: Obstacle)

const OBSTACLE_FIRE_DAMAGE: int = 1

var tile: GridTile
var transmuted_state: TransmutedState = TransmutedState.DEFAULT

@onready var health: Health = $Health
@onready var model: ObstacleModel = $ObstacleModel1 # Selects the default obstacle model in case there are no extras
@onready var burning_state: BurningState = $BurningState
@onready var destroy_timer: Timer = $DestroyTimer
@onready var destroy_audio: AudioRandomizer = $DestroyAudio

@export var data: ObstacleData
@export var alternate_models: Array[ObstacleModel] # Optional array. If there are variations of the same model, can list them all here to choose randomly
@export var behaviors: Array[ObstacleBehavior] # Optional array of behaviors
@export var light_anchor: Node2D

@export var default_break_sound: AudioStream
@export var quartz_break_sound: AudioStream
@export var rock_break_sound: AudioStream
@export var tree_break_sound: AudioStream

var light_circle: LightCircle
var loot: Dictionary
var num_surrounding_lights = 0

func _process(delta: float) -> void:
    for behavior: ObstacleBehavior in behaviors:
        # Quick null check just in case
        if behavior:
            behavior.update(self, delta)

    # Quartz obstacles can receive light sources from OBSTACLES only (not moving objects/enemies)
    # Also assumes quartz cannot also be caught on fire
    if transmuted_state == TransmutedState.QUARTZ:
        calc_num_surrounding_lights()
        if num_surrounding_lights <= 0 and has_light():
            delete_light()
        elif num_surrounding_lights > 0 and not has_light():
            light_circle = GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.QUARTZ_LIGHT_RADIUS, LightManager.Type.QUARTZ)

func calc_num_surrounding_lights() -> void:
    num_surrounding_lights = 0
    var neighbors: Array[GridTile] = GlobalVariables.get_grid().get_neighbors(tile, false, false)
    for neighbor in neighbors:
        if neighbor.obstacle and neighbor.obstacle.has_light():
            num_surrounding_lights += 1

func has_light() -> bool:
    return light_circle != null and is_instance_valid(light_circle)

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
    if state == data.transmuted_base_type:
        return reset_transmuted_state()
    var success: bool = model.set_transmuted_state(state)
    if success:
        transmuted_state = state
        on_transmuted_state_change()
        _update_audio()
    transmuted.emit(self)
    for behavior: ObstacleBehavior in behaviors:
        # Quick null check just in case
        if behavior:
            behavior.on_transmute(self, state)
    return success

func _update_audio() -> void:
    var new_audio: AudioStream = null
    if transmuted_state == TransmutedState.DEFAULT:
        new_audio = default_break_sound
    elif transmuted_state == TransmutedState.QUARTZ and quartz_break_sound:
        new_audio = quartz_break_sound
    elif transmuted_state == TransmutedState.STONE and rock_break_sound:
        new_audio = rock_break_sound
    elif transmuted_state == TransmutedState.WOOD and tree_break_sound:
        new_audio = tree_break_sound

    if new_audio:
        destroy_audio.audio_tracks = [new_audio]


func reset_transmuted_state() -> bool:
    transmuted_state = TransmutedState.DEFAULT
    model.set_transmuted_state(transmuted_state)
    _update_audio()
    update_health_from_transmutation(transmuted_state)
    if burning_state.is_burning() and not is_flammable():
        put_out_fire()
    burning_state.is_burned = false
    transmuted.emit(self)
    for behavior: ObstacleBehavior in behaviors:
        # Quick null check just in case
        if behavior:
            behavior.on_transmute(self, TransmutedState.DEFAULT)
    return true

func on_transmuted_state_change():
    update_health_from_transmutation(transmuted_state)
    if burning_state.is_burning() and not is_flammable():
        put_out_fire()
    burning_state.is_burned = false

# Health updates to match the material after transmutating
func update_health_from_transmutation(state: TransmutedState) -> void:
    # Formula: New Health = (Current Health / Max Health) * Size Multiplier * Material Multiplier
    var health_percent = health.get_percentage()
    var material_multiplier = get_material_multiplier(state)
    var new_health: int = ceili(health_percent * data.size_multiplier * material_multiplier)
    var new_max_health: int = ceili(data.size_multiplier * material_multiplier)
    print("Transmutated health ", health_percent, " of ", Type.keys()[data.id], " to ", TransmutedState.keys()[state], " = ", new_health)
    health.set_max_health(new_max_health)
    health.set_health(new_health)

func get_material_multiplier(state: TransmutedState) -> int:
    match state:
        TransmutedState.DEFAULT:
            return data.health
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

    # Spawn light
    if has_light():
        return
    light_circle = GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.FLAMING_OBJECT_LIGHT_RADIUS, LightManager.Type.FIRE)

func put_out_fire() -> void:
    burning_state.reset_burning_time()
    model.set_flaming(false)
    if has_light() and data.id != Obstacle.Type.TORCH:
        delete_light()

# Must always be preceded by a has_light() check
func delete_light() -> void:
    light_circle.queue_free()
    light_circle = null

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
    init_loot()
    for behavior: ObstacleBehavior in behaviors:
        # Quick null check just in case
        if behavior:
            behavior.init(self)
    destroy_audio.audio_tracks = [default_break_sound]

func init_loot() -> void:
    loot = data.loot.resolve()

func _on_burning_state_fire_tick() -> void:
    damage(OBSTACLE_FIRE_DAMAGE)
    # Don't spread fire till after the first tick
    if burning_state.total_time_burned < 1.0:
        return

    var chance_spread = 0.1
    if data.id == Obstacle.Type.OIL_SPILL:
        chance_spread = 0.25
    _spread_fire(chance_spread)

func _spread_fire(chance: float) -> void:
    var neighbors: Array[GridTile] = GlobalVariables.get_grid().get_neighbors(tile, true)
    for neighbor in neighbors:
        if randf() < chance and neighbor.obstacle:
            neighbor.obstacle.set_on_fire(GlobalVariables.FIRE_SPREAD_DURATION)

func _on_burning_state_fire_expired() -> void:
    put_out_fire()

func _transmute_loot() -> Dictionary:
    var transmuted_type: Pickup.PickupType = Pickup.PickupType.SHADOWSAND
    var should_transmute = false
    match transmuted_state:
        TransmutedState.WOOD:
            transmuted_type = Pickup.PickupType.SAP
            should_transmute = true
        TransmutedState.QUARTZ:
            transmuted_type = Pickup.PickupType.QUARTZ
            should_transmute = true
        TransmutedState.STONE:
            transmuted_type = Pickup.PickupType.STONE
            should_transmute = true

    if not should_transmute or transmuted_type == null:
        return loot

    var sum: int = 0
    for value in loot.values():
        sum += value

    var result = {}
    result[transmuted_type] = sum
    return result

func create_pickup_drops():
    var adjusted_loot = _transmute_loot()
    for item: Pickup.PickupType in adjusted_loot.keys():
        var count: int = adjusted_loot[item]
        GlobalVariables.get_pickup_manager().spawn_pickup_drop(item, global_position, count)

func _on_health_death() -> void:
    # FIXME: Stretch goal to put an animation here
    destroy_timer.start()
    destroy_audio.play_random()
    hide()
    create_pickup_drops()

func _on_burning_state_burnt() -> void:
    if data.should_use_burnt_texture:
        model.set_burned_overlay()
        burning_state.is_burned = true

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

func _on_destroy_timer_timeout() -> void:
    removed.emit()
