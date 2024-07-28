extends ProjectileBehavior

class_name TorchBehavior

@export var light_anchor: Node2D

func on_ready(_projectile: ThrownProjectile):
    GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.TORCH_LIGHT_RADIUS, LightManager.Type.TORCH)

func on_land(_pos: Vector2):
    # TODO: If it hits any enemies, light them on fire

    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(_pos)
    if tile == null:
        return
    if tile.obstacle:
        tile.obstacle.set_on_fire(GlobalVariables.TORCH_FIRE_DURATION)
    else:
        obstacle_manager.spawn_obstacle(Obstacle.Type.TORCH, tile)
