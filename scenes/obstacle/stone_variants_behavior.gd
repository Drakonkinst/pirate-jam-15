extends ObstacleBehavior

class_name StoneVariantsBehavior

@export var tree_crystal: Texture2D
@export var fire_crystal: Texture2D
@export var quartz_crystal: Texture2D

var texture_adjusted: bool = false
# The better way to do this would be to make a dedicated downstream function on init but ah well
func update(obstacle: Obstacle, _delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        texture_adjusted = false
        return
    if texture_adjusted:
        return
    var base_texture: Texture2D = null
    if _has_at_least_one(Pickup.PickupType.FIRE, obstacle):
        base_texture = fire_crystal
    elif _has_at_least_one(Pickup.PickupType.QUARTZ, obstacle):
        base_texture = quartz_crystal
    elif _has_at_least_one(Pickup.PickupType.SAP, obstacle):
        base_texture = tree_crystal
    if base_texture:
        obstacle.model.set_base_texture(base_texture)


func _has_at_least_one(pickup_type: Pickup.PickupType, obstacle: Obstacle) -> bool:
    return pickup_type in obstacle.loot and obstacle.loot[pickup_type] > 0
