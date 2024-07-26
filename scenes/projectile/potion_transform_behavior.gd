extends ProjectileBehavior

class_name PotionTransformBehavior

@export var transform_into: Obstacle.TransmutedState

func on_land(pos: Vector2):
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, GlobalVariables.POTION_RADIUS)
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    projectile_manager.place_explosion(pos).set_color(tint_color)
    projectile_manager.place_splat(pos).set_color(tint_color)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle.set_transmuted_state(transform_into)

