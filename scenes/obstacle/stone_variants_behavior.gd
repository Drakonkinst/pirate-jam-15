extends ObstacleBehavior

class_name StoneVariantsBehavior

@export var tree_crystal: Texture2D
@export var fire_crystal: Texture2D
@export var quartz_crystal: Texture2D

var is_quartz: bool = false

func init(obstacle: Obstacle) -> void:
    _update_model(obstacle)

func on_transmuted(obstacle: Obstacle, _to: Obstacle.TransmutedState) -> void:
    _update_model(obstacle)

func _update_model(obstacle: Obstacle) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        return
    is_quartz = false
    var base_texture: Texture2D = null
    if _has_at_least_one(Pickup.PickupType.FIRE, obstacle):
        base_texture = fire_crystal
    elif _has_at_least_one(Pickup.PickupType.QUARTZ, obstacle):
        base_texture = quartz_crystal
        is_quartz = true
    elif _has_at_least_one(Pickup.PickupType.SAP, obstacle):
        base_texture = tree_crystal
    if base_texture:
        obstacle.model.set_base_texture(base_texture)

func update(obstacle: Obstacle, _delta: float) -> void:
    if obstacle.transmuted_state == Obstacle.TransmutedState.DEFAULT and is_quartz:
        obstacle.calc_num_surrounding_lights()
        print(obstacle.num_surrounding_lights)
        if obstacle.num_surrounding_lights > 0 and not obstacle.has_light():
            obstacle.light_circle = GlobalVariables.get_light_manager().spawn_tracking(obstacle.light_anchor, GlobalVariables.QUARTZ_CRYSTAL_LIGHT_RADIUS, LightManager.Type.QUARTZ)
        elif obstacle.num_surrounding_lights <= 0 and obstacle.has_light():
            obstacle.delete_light()

func _has_at_least_one(pickup_type: Pickup.PickupType, obstacle: Obstacle) -> bool:
    return pickup_type in obstacle.loot and obstacle.loot[pickup_type] > 0
