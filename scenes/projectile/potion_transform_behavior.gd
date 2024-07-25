extends ProjectileBehavior

class_name PotionTransformBehavior

@export var transform_into: Obstacle.TransmutedState

func on_land(pos: Vector2):
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, GlobalVariables.POTION_RADIUS)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle.set_transmuted_state(transform_into)

