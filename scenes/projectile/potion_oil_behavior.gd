extends ProjectileBehavior

class_name PotionOilBehavior

func on_land(pos: Vector2):
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var projectile_manager: ProjectileManager = GlobalVariables.get_projectile_manager()
    projectile_manager.place_explosion(pos).set_color(tint_color)
    projectile_manager.place_splat(pos).set_color(tint_color)
    var tiles: Array[GridTile] = GlobalVariables.get_grid().get_tiles_in_radius(pos, GlobalVariables.POTION_RADIUS)
    for tile: GridTile in tiles:
        var obstacle: Obstacle = tile.obstacle
        if obstacle == null or not obstacle.data.can_transform:
            continue
        obstacle_manager.replace_obstacle(Obstacle.Type.OIL_SPILL, tile)

