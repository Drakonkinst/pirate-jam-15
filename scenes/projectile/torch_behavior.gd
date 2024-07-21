extends ProjectileBehavior

class_name TorchBehavior

@export var fire_time: float = 5.0

func on_land(_pos: Vector2):
    # TODO: If it hits any enemies, light them on fire

    # TODO: A bug in screenspace_to_tiles makes this slightly offset. Need to look into this
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(_pos)
    if tile == null:
        return
    if tile.obstacle:
        tile.obstacle.set_on_fire(fire_time)
    else:
        obstacle_manager.spawn_obstacle(Obstacle.Type.TORCH, tile)
