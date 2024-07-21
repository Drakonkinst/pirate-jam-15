extends ProjectileBehavior

class_name PotionTransformBehavior

@export var transform_into: Obstacle.TransmutedState
@export var radius: float = 150

func on_land(pos: Vector2):
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, radius)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle.set_transmuted_state(transform_into)

