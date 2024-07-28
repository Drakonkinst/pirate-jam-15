extends ProjectileBehavior

class_name TorchBehavior

@export var light_anchor: Node2D

func on_ready(_projectile: ThrownProjectile):
    GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.TORCH_LIGHT_RADIUS, LightManager.Type.TORCH)

func on_land(_pos: Vector2):
    var obstacle_manager: ObstacleManager = GlobalVariables.get_obstacle_manager()
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(_pos)
    # TODO: Light any enemies in the same tile on fire
    if tile == null:
        return

    var can_replace := true
    if tile.obstacle and not tile.obstacle.data.replaceable:
        can_replace = false
    if can_replace:
        obstacle_manager.replace_obstacle(Obstacle.Type.TORCH, tile)
    else:
        tile.obstacle.set_on_fire(GlobalVariables.TORCH_FIRE_DURATION)
