extends ProjectileBehavior

class_name PotionOilBehavior

@export var radius: float = 150

func on_land(pos: Vector2):
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, radius)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle_manager.replace_obstacle(Obstacle.Type.OIL_SPILL, tile)

