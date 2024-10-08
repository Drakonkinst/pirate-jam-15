extends PotionBehavior

class_name PotionOilBehavior

func on_land(pos: Vector2):
    super(pos)
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, GlobalVariables.POTION_RADIUS)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle_manager.replace_obstacle(Obstacle.Type.OIL_SPILL, tile)
        GlobalVariables.curr_game.score += 20

